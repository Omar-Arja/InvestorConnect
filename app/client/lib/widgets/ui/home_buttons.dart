import 'package:flutter/material.dart';
import 'package:client/widgets/ui/ai_modal.dart';

class HomeButtons extends StatelessWidget {
  final Function leftButton;
  final Function rightButton;

  const HomeButtons({super.key, required this.leftButton, required this.rightButton});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      margin: const EdgeInsets.only(top: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.1,
            width: MediaQuery.of(context).size.height * 0.1,
            decoration:  BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(50)),
              color: const Color.fromARGB(255, 239, 83, 80),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.5),
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Center(
              child: IconButton(
                iconSize: 45,
                visualDensity: VisualDensity.compact,
                color: const Color.fromARGB(255, 54, 54, 55),
                icon: const Icon(Icons.close_rounded),
                onPressed: () {
                  leftButton();
                },
              ),
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.1,
            width: MediaQuery.of(context).size.height * 0.1,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(50)),
              color: const Color.fromARGB(255, 248, 210, 112),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.5),
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Center(
              child: GestureDetector(
                onTap: () {
                  showModalBottomSheet(context: context, builder: (context) => const AiModal());
                },
                child: const ImageIcon(
                  AssetImage('assets/images/chatgpt_logo.png'),
                  size: 68,
                  color: Color.fromARGB(255, 54, 54, 55),
                ),
              ),
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.1,
            width: MediaQuery.of(context).size.height * 0.1,
            decoration:  BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(50)),
              color: const Color.fromARGB(255, 155, 218, 171),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.5),
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Center(
              child: IconButton(
                iconSize: 45,
                visualDensity: VisualDensity.compact,
                color: const Color.fromARGB(255, 54, 54, 55),
                icon: const Icon(Icons.arrow_forward_rounded),
                onPressed: () {
                  rightButton();
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}