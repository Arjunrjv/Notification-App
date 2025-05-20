import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:notification_app/screens/detailspage.dart';

class SentMessages extends StatefulWidget {
  const SentMessages({Key? key}) : super(key: key);

  @override
  State<SentMessages> createState() => _SentMessagesState();
}

class _SentMessagesState extends State<SentMessages> {
  bool _showLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDataFromFirebase();
  }

  Future<void> _loadDataFromFirebase() async {
    try {
      // Fetch data from Firebase
      await getSentMessages().first;

      if (mounted) {
        setState(() {
          _showLoading = false;
        });
      }
    } catch (error) {
      print('Error loading data: $error');
      // Handle the error as needed
      if (mounted) {
        setState(() {
          _showLoading = false;
        });
      }
    }
  }

  final DatabaseReference messagesRef =
      FirebaseDatabase.instance.ref().child('messages');

  Future<void> deleteMessage(BuildContext context, String messageId) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Confirm Deletion',
            style: TextStyle(
              color: Colors.black,
              fontSize: 32,
              fontWeight: FontWeight.w800,
              fontFamily: 'Gilroy',
            ),
          ),
          content: const Text(
            'Are you sure you want to delete this message?',
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.w500,
              fontFamily: 'Gilroy',
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                setState(() {});
                Navigator.of(context).pop();
              },
              child: const Text(
                'Cancel',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Gilroy',
                ),
              ),
            ),
            TextButton(
              onPressed: () async {
                await messagesRef.child(messageId).remove();
                Navigator.of(context).pop();
              },
              child: const Text(
                'Delete',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Gilroy',
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Stream<List<Map<String, dynamic>>> getSentMessages() async* {
    yield* messagesRef.onValue.map((event) {
      final dataSnapshot = event.snapshot;

      final values = dataSnapshot.value as Map<dynamic, dynamic>;

      final List<Map<String, dynamic>> sentMessages = [];

      values.forEach((key, value) {
        // Check if the message has senderId (indicating it's a sent message)
        if (value['senderId'] != null) {
          sentMessages.add({
            'id': key, // Add the message ID
            'title': value['title'] ?? '',
            'message': value['message'] ?? '',
            'fileURL': value['fileURL'] ?? '', // Add file URL
            'timestamp': value['timestamp'] ?? 0,
          });
        }
      });

      // Sort sent messages by timestamp (you can adjust sorting logic based on your requirements)
      sentMessages.sort((a, b) => b['timestamp'].compareTo(a['timestamp']));

      return sentMessages;
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: getSentMessages(),
      builder: (context, snapshot) {
        if (_showLoading) {
          return Center(
            child: LoadingAnimationWidget.staggeredDotsWave(
              color: const Color(0xFFD1C3DB),
              size: 40,
            ),
          );
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No sent messages available.'));
        } else {
          final sentMessages = snapshot.data!;

          // Check if the sentMessages list is empty
          if (sentMessages.isEmpty) {
            return const Center(child: Text('No sent messages available.'));
          }

          return ListView.builder(
            itemCount: sentMessages.length,
            itemBuilder: (context, index) {
              final messageId = sentMessages[index]['id'];
              // final fileURL = sentMessages[index]['fileURL']; // Get file URL
              return Dismissible(
                key: UniqueKey(),
                direction: DismissDirection.endToStart,
                onDismissed: (_) {
                  deleteMessage(context, messageId);
                },
                background: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.red,
                  ),
                  child: const Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      'Deleting',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        fontFamily: 'Gilroy',
                      ),
                    ),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MessageDetailsPage(
                              title: sentMessages[index]['title'] ?? '',
                              messageContent:
                                  sentMessages[index]['message'] ?? '',
                              fileName: sentMessages[index]['fileName'] ?? '',
                              containerColor: Color(0xFFD1C3DB),
                            ),
                          ));
                    },
                    child: Container(
                      decoration: const BoxDecoration(
                          shape: BoxShape.rectangle,
                          color: Color(0xFFD1C3DB),
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      child: ListTile(
                        title: Text(
                          sentMessages[index]['title'] ?? '',
                          style: const TextStyle(
                              color: Colors.black,
                              fontFamily: 'Gilroy',
                              fontSize: 16,
                              fontWeight: FontWeight.w900),
                        ),
                        subtitle: const Text(
                          'Sender: Principal',
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'Gilroy',
                              fontSize: 14,
                              fontWeight: FontWeight.w400),
                        ),
                        trailing: Container(
                          height: 20,
                          width: 20,
                          decoration: BoxDecoration(
                            color: const Color(0xff323232),
                            borderRadius: BorderRadiusDirectional.circular(4),
                          ),
                          child: const Icon(
                            Iconsax.link5,
                            size: 14,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }
}
