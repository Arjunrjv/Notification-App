import 'dart:io';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:file_picker/file_picker.dart';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../widgets/messagecompose.dart';

class ComposeMessage extends StatefulWidget {
  ComposeMessage({super.key});

  @override
  State<ComposeMessage> createState() => _ComposeMessageState();
}

class _ComposeMessageState extends State<ComposeMessage> {
  final TextEditingController titleController = TextEditingController();

  final TextEditingController messageController = TextEditingController();

  var path;
  PlatformFile? pickedFile;

  String? fileURL; // Added variable to store the fileURL

  Future<void> _pickAndUploadFiles() async {
    if (pickedFile == null) {
      try {
        final result = await FilePicker.platform.pickFiles();
        if (result == null) return;

        setState(() {
          pickedFile = result.files.first;
        });

        // await _uploadFilesToFirebase(); // Call the upload function after picking the file.
      } catch (e) {
        print('Error picking/uploading file: $e');
        // Handle the error as needed
      }
    }
  }

  Future<void> _uploadFilesToFirebase() async {
    if (pickedFile == null) {
      print('No file picked for upload.');
      return;
    }

    try {
      final path = 'files/${pickedFile!.name}';
      final file = File(pickedFile!.path!);

      final ref = FirebaseStorage.instance.ref().child(path);
      await ref.putFile(file);

      // Get the download URL of the uploaded file
      fileURL = await ref.getDownloadURL(); // Set the fileURL
    } catch (e) {
      print('Error uploading file: $e');
      // Handle the error as needed
    }
  }

  Future<void> sendAllMessage(
      String title, String message, String fileName, String? fileURL) async {
    try {
      await FirebaseDatabase.instance.ref().child('messages').push().set({
        'title': title,
        'message': message,
        'fileName': fileName,
        'fileURL': fileURL,
        'timestamp': ServerValue.timestamp,
      }).then((value) {
        print("Message sent to Realtime Database");
      }).catchError((error) {
        print("Failed to send message: $error");
      });
    } catch (error) {
      print("Error: $error");
    }
  }

  // Future<void> sendTeacherMessage(
  //     String title, String message, String fileName, String? fileURL) async {
  //   try {
  //     await FirebaseDatabase.instance
  //         .ref()
  //         .child('teacherMessages')
  //         .push()
  //         .set({
  //       'title': title,
  //       'message': message,
  //       'fileName': fileName,
  //       'fileURL': fileURL,
  //       'timestamp': ServerValue.timestamp,
  //     }).then((value) {
  //       print("Teacher message sent to Realtime Database");
  //     }).catchError((error) {
  //       print("Failed to send teacher message: $error");
  //     });
  //   } catch (error) {
  //     print("Error: $error");
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey, width: 2),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Enter title for the message',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Gilroy',
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: titleController,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Gilroy',
                    ),
                    decoration: const InputDecoration(
                      hintText: 'Enter message title',
                      hintStyle: TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'Gilroy',
                      ),
                      border: InputBorder.none,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Container(
                padding: const EdgeInsets.all(16),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey, width: 2),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Compose a Message',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Gilroy',
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: messageController,
                      maxLines: null,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Gilroy',
                      ),
                      decoration: const InputDecoration(
                        hintText: 'Write your message here',
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          fontFamily: 'Gilroy',
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: IconButton(
                      icon: const Icon(Iconsax.document_upload),
                      color: Colors.white,
                      onPressed: () async {
                        await _pickAndUploadFiles();
                      },
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      // Show the dialog to select options
                      // bool sendToAll = await showDialog(
                      //       context: context,
                      //       builder: (BuildContext context) {
                      //         return const MessageComposeDialog();
                      //       },
                      //     ) ??
                      //     false;
                      String title = titleController.text;
                      String message = messageController.text;
                      if (title.isNotEmpty && message.isNotEmpty) {
                        // Wait for file upload to complete
                        await _uploadFilesToFirebase();

                        // Determine whether to send to students or teachers based on the dialog selection

                        // Send to both students and teachers
                        await sendAllMessage(
                            title, message, pickedFile?.name ?? "", fileURL);

                        titleController.clear();
                        messageController.clear();

                        // await AwesomeNotifications().createNotification(
                        //     content: NotificationContent(
                        //       id: id,
                        //       channelKey: 'scheduled',
                        //       title: 'Wait 5 seconds to show',
                        //       body: 'Now it is 5 seconds later.',
                        //       wakeUpScreen: true,
                        //       category: NotificationCategory.Alarm,
                        //     ),
                        //     schedule: NotificationInterval(
                        //         interval: 5,
                        //         timeZone: localTimeZone,
                        //         preciseAlarm: true,
                        //         timezone: await AwesomeNotifications()
                        //             .getLocalTimeZoneIdentifier()));
                      } else {
                        // Handle empty title or message case if needed
                        print("Title or message is empty.");
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE4D9CD),
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Send',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Gilroy',
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 5),
                          child: Icon(Iconsax.send_14),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
