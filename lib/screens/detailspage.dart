import 'dart:io';
import 'package:dio/dio.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class MessageDetailsPage extends StatelessWidget {
  final String title;
  final String messageContent;
  final String? fileName;
  final String? fileURL;
  final containerColor;

  const MessageDetailsPage({
    Key? key,
    required this.title,
    required this.messageContent,
    this.fileName,
    this.fileURL,
    required this.containerColor,
  }) : super(key: key);

  Future<void> downloadAndOpenFile(String fileURL, BuildContext context) async {
    try {
      // Assuming fileURL is directly obtained from the database and is a full URL
      // Extract the file extension from the URL
      final fileExtension =
          Uri.parse(fileURL).pathSegments.last.split('.').last;

      // Create a temporary directory
      final directory = await Directory.systemTemp;
      final filePath = '${directory.path}/file.$fileExtension';

      // Download the file
      final dio = Dio();
      await dio.download(fileURL, filePath);

      // Open the downloaded file
      if (await canLaunchUrl(Uri.parse(filePath))) {
        await launchUrl(Uri.parse(filePath));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Could not open the file. Invalid URL format.'),
          ),
        );
      }
    } catch (e) {
      print('Error opening file: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('An error occurred while opening the file.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    print('FileName: $fileName');
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  height: 80,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: containerColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      title,
                      style: const TextStyle(
                          color: Colors.black,
                          fontFamily: 'Gilroy',
                          fontSize: 16,
                          fontWeight: FontWeight.w900),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: containerColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        messageContent,
                        style: const TextStyle(
                            color: Colors.black,
                            fontFamily: 'Gilroy',
                            fontSize: 16,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                ),
                if (fileName != null)
                  GestureDetector(
                    onTap: () {
                      downloadAndOpenFile(
                          'https://firebasestorage.googleapis.com/v0/b/notificationapp-23f26.appspot.com/o/files%2FBRIGHTSIDE.pptx?alt=media&token=1605fd7a-321f-410c-9bc1-cc8f5389524d',
                          context);
                    },
                    child: Container(
                      height: 80,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: containerColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          fileName!,
                          style: const TextStyle(
                            color: Colors.black,
                            fontFamily: 'Gilroy',
                            fontSize: 14,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ),
                  )
                else
                  Container(
                    height: 80,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: containerColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Center(
                      child: Text(
                        'No File Attached',
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Gilroy',
                          fontSize: 14,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
