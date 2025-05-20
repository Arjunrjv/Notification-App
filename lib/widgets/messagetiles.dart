import 'package:flutter/material.dart';

class MessageTiles extends StatelessWidget {
  String? title, subtitle;
  String? img;
  bool isRead = false;
  final VoidCallback? onTap;

  MessageTiles({
    super.key,
    required this.img,
    required this.title,
    required this.subtitle,
    required this.isRead,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 60,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: isRead ? const Color(0xff161616) : const Color(0xffF3F1EF),
            borderRadius: const BorderRadius.all(Radius.circular(10))),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.black,
              foregroundImage: AssetImage(img!),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 12, right: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title!,
                    style: TextStyle(
                        fontFamily: 'Gilroy',
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: isRead
                            ? const Color(0xffFFFFFF)
                            : const Color(0xff000000)),
                  ),
                  Text(
                    subtitle!,
                    style: TextStyle(
                        fontFamily: 'Gilroy',
                        fontSize: 8,
                        fontWeight: FontWeight.w500,
                        color: isRead
                            ? const Color(0xffFFFFFF)
                            : const Color(0xff000000)),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 30),
              child: Row(
                children: [
                  Container(
                    height: 20,
                    width: 20,
                    decoration: BoxDecoration(
                      color: isRead
                          ? const Color(0xff323232)
                          : const Color(0xffE4D9CD),
                      borderRadius: BorderRadiusDirectional.circular(4),
                    ),
                    child: Icon(
                      Icons.description_outlined,
                      size: 14,
                      color: isRead
                          ? const Color(0xffFFFFFF)
                          : const Color(0xff2C2C2C),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 5),
                    child: Container(
                      height: 20,
                      width: 20,
                      decoration: BoxDecoration(
                        color: isRead
                            ? const Color(0xff323232)
                            : const Color(0xffE4D9CD),
                        borderRadius: BorderRadiusDirectional.circular(4),
                      ),
                      child: Icon(
                        Icons.link_outlined,
                        size: 14,
                        color: isRead
                            ? const Color(0xffFFFFFF)
                            : const Color(0xff2C2C2C),
                      ),
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
