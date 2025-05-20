import 'package:flutter/material.dart';

class PinnedContainer extends StatelessWidget {
  const PinnedContainer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 160,
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xffE2D6E8),
        borderRadius: BorderRadiusDirectional.circular(12),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 12, top: 12, right: 12),
            child: Row(
              children: [
                const CircleAvatar(
                  backgroundColor: Colors.black,
                  foregroundImage: AssetImage('assets/images/Group 1.png'),
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 12, right: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Register for Examination',
                        style: TextStyle(
                            fontFamily: 'Gilroy',
                            fontSize: 16,
                            fontWeight: FontWeight.w400),
                      ),
                      Text(
                        'Principal',
                        style: TextStyle(
                            fontFamily: 'Gilroy',
                            fontSize: 8,
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 4),
                  child: Container(
                    height: 20,
                    width: 20,
                    decoration: BoxDecoration(
                      color: const Color(0xffD1C3DB),
                      borderRadius: BorderRadiusDirectional.circular(4),
                    ),
                    child: const Icon(
                      Icons.description_outlined,
                      size: 14,
                      color: Color(0xff2C2C2C),
                    ),
                  ),
                ),
                Container(
                  height: 20,
                  width: 20,
                  decoration: BoxDecoration(
                    color: const Color(0xffD1C3DB),
                    borderRadius: BorderRadiusDirectional.circular(4),
                  ),
                  child: const Icon(
                    Icons.link_outlined,
                    size: 14,
                    color: Color(0xff2C2C2C),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 12, left: 24, right: 24),
            child: RichText(
              text: const TextSpan(
                children: [
                  TextSpan(
                    text:
                        "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a +read more",
                    style: TextStyle(
                      color: Color(0xff444444),
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'Gilroy',
                    ),
                  ),
                  TextSpan(
                    text: '+read more',
                    style: TextStyle(
                      color: Color(0xff444444),
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Gilroy',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
