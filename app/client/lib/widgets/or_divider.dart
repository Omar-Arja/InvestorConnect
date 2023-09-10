import 'package:flutter/material.dart';

class OrDivider extends StatelessWidget {

  const OrDivider({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: 334,
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: Divider(
              color: Color.fromARGB(255, 96, 96, 96),
              thickness: 1,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              'or',
              style: TextStyle(
                fontSize: 17,
                color: Color.fromARGB(255, 96, 96, 96),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Divider(
              color: Color.fromARGB(255, 96, 96, 96),
              thickness: 1,
            ),
          ),
        ],
      ),
    );
  }
}
