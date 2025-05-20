import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:notification_app/screens/detailspage.dart';

import '../login.dart';

class HomePage extends StatefulWidget {
  final String? userEmail;

  const HomePage({Key? key, this.userEmail}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final DatabaseReference _databaseReference =
      FirebaseDatabase.instance.ref().child('messages');

  void _signOut(BuildContext context) async {
    // Show an AlertDialog before logging out the user
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xffE2D6E8),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadiusDirectional.circular(12)),
        title: const Text(
          'Log out',
          style: TextStyle(
            color: Colors.black,
            fontSize: 32,
            fontWeight: FontWeight.w800,
            fontFamily: 'Gilroy',
          ),
        ),
        content: const Text(
          'Are you sure you want to log out?',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w500,
            fontFamily: 'Gilroy',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
                fontWeight: FontWeight.w600,
                fontFamily: 'Gilroy',
              ),
            ),
          ),
          TextButton(
            onPressed: () async {
              // Log out the user
              await FirebaseAuth.instance.signOut();

              // Navigate to the login page after successful logout
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => const LoginPage(),
                ),
              );
            },
            child: const Text(
              'Log out',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                fontFamily: 'Gilroy',
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.userEmail!,
                      style: TextStyle(
                          color: Colors.white.withOpacity(0.40),
                          fontFamily: 'Gilroy',
                          fontSize: 12,
                          fontWeight: FontWeight.w400),
                    ),
                    GestureDetector(
                      onTap: () {
                        _signOut(context);
                      },
                      child: const CircleAvatar(
                        backgroundColor: Color(0xffE2D6E8),
                        child: Icon(
                          Iconsax.user_octagon4,
                          color: Colors.black,
                        ),
                      ),
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Text(
                    'New messages',
                    style: TextStyle(
                        color: Colors.white.withOpacity(0.40),
                        fontFamily: 'Gilroy',
                        fontSize: 12,
                        fontWeight: FontWeight.w800),
                  ),
                ),
                StreamBuilder<DatabaseEvent>(
                  stream: _databaseReference.onValue,
                  builder: (BuildContext context,
                      AsyncSnapshot<DatabaseEvent> snapshot) {
                    if (snapshot.hasData &&
                        snapshot.data != null &&
                        snapshot.data!.snapshot.value != null) {
                      DataSnapshot dataSnapshot = snapshot.data!.snapshot;
                      Map<dynamic, dynamic>? messages =
                          dataSnapshot.value as Map?;
                      List<Map<String, dynamic>> messageList = [];

                      if (messages != null) {
                        messages.forEach((key, message) {
                          String messageText = message['message'];
                          String messageTitle = message['title'];
                          // String senderId = message['senderId'];
                          int timestamp = message['timestamp'];

                          messageList.add({
                            'title': messageTitle,
                            'message': messageText,
                            'timestamp': timestamp,
                            'fileName': message['fileName'] ?? '',
                            'fileURL': message['fileURL'],
                          });
                        });

                        // Sort messages based on timestamp
                        messageList.sort((a, b) {
                          int timestampA = a['timestamp'];
                          int timestampB = b['timestamp'];
                          return timestampB.compareTo(timestampA);
                        });
                      }

                      return Column(
                        children: messageList.map((message) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MessageDetailsPage(
                                      title: message['title'] ?? '',
                                      messageContent: message['message'] ?? '',
                                      fileName: message['fileName'] ?? '',
                                      fileURL: message['fileURL'],
                                      containerColor: const Color(0xffE2D6E8),
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                decoration: const BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  color: const Color(0xffE2D6E8),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                ),
                                child: ListTile(
                                  title: Text(
                                    message['title'],
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontFamily: 'Gilroy',
                                      fontSize: 16,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                  subtitle: const Text(
                                    'Sender: Principal',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: 'Gilroy',
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  trailing: Container(
                                    height: 20,
                                    width: 20,
                                    decoration: BoxDecoration(
                                      color: const Color(0xff323232),
                                      borderRadius:
                                          BorderRadiusDirectional.circular(4),
                                    ),
                                    child: const Icon(
                                      Icons.link_outlined,
                                      size: 14,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      );
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xffE2D6E8),
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                backgroundColor: const Color(0xffE2D6E8),
                title: const Text(
                  'Add Comment',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Gilroy',
                  ),
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const TextField(
                      cursorColor: Colors.black,
                      // controller: commentController,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Gilroy',
                      ),
                      decoration: InputDecoration(
                        hintText: 'Enter comment text',
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          fontFamily: 'Gilroy',
                        ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                            borderSide:
                                BorderSide(color: Colors.grey, width: 2)),
                        // focusColor: const Color(0xffE4D9CD),
                      ),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xffE2D6E8),
                      ),
                      onPressed: () {
                        // Add comment to database
                        Navigator.of(context).pop();
                      },
                      child: const Text(
                        'Add',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Gilroy',
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
        child: const Icon(
          Iconsax.messages4,
          size: 48,
          color: Colors.black,
        ),
      ),
    );
  }
}
