import 'package:client/models/profile.dart';
import 'package:flutter/material.dart';

class AiModal extends StatelessWidget {
  final Profile? currentProfile;

  const AiModal({super.key, this.currentProfile });

  @override
  Widget build(BuildContext context) {

    return Container(
      padding: const EdgeInsets.only(top: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundImage: NetworkImage(
                        currentProfile == null ? '' : currentProfile!.pictureUrl,
                      ),
                      backgroundColor: const Color.fromARGB(255, 76, 104, 175),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          currentProfile == null ? 'No Profile selected' : currentProfile!.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const Text('AI Analysis'),
                      ],
                    )
                  ],
                ),
                const CircleAvatar(
                  radius: 22,
                  backgroundColor: Color.fromARGB(255, 248, 210, 112),
                  backgroundImage: AssetImage('assets/images/chatgpt_logo.png'),
                ),
              ],
            ),
          ),
          const Divider(
            color: Color.fromARGB(25, 0, 0, 0),
            thickness: 1,
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.fromLTRB(14, 0, 10, 8),
              height: MediaQuery.of(context).size.height * 0.7,
              child: ListView(
                children: [
                  const Text(
                    'Analysis Result',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    currentProfile == null ? 'No Profile selected' : currentProfile!.aiAnalysis,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              )
            ),
          )
        ],
      )
    );
  }
}
