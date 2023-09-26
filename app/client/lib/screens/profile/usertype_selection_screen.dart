import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:client/widgets/buttons/custom_buttons.dart';

class UsertypeSelectionScreen extends StatefulWidget {
  const UsertypeSelectionScreen({super.key});

  @override
  State<UsertypeSelectionScreen> createState() => _UsertypeSelectionScreenState();
}

class _UsertypeSelectionScreenState extends State<UsertypeSelectionScreen> {
  String selectedUsertype = '';

  void selectUsertype(String usertype) {
    setState(() {
      selectedUsertype = usertype;
    });
  }

  Widget buildUsertypeBox(String usertype, String title, String imagePath, String activeImagePath) {
    final isSelected = selectedUsertype == usertype;
    return GestureDetector(
      onTap: () {
        selectUsertype(usertype);
      },
      child: Container(
        width: double.infinity,
        height: 269,
        margin: const EdgeInsets.symmetric(vertical: 10),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        decoration: BoxDecoration(
          color: isSelected ? Theme.of(context).primaryColor : Colors.white,
          borderRadius: BorderRadius.circular(5),
          border: Border.all(
            color: isSelected ? Colors.transparent : const Color.fromARGB(30, 0, 0, 0),
            width: 1,
          ),
          boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundColor: const Color.fromARGB(255, 76, 104, 175),
              backgroundImage: AssetImage(isSelected ? activeImagePath : imagePath),
            ),
            const SizedBox(height: 10),
            Text(
              title,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w500,
                color: isSelected ? Colors.white : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
        ),
        centerTitle: true,
        title: const Text(
          'Are you a?',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        leading: IconButton(
          padding: const EdgeInsets.only(left: 25),
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: ListView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                buildUsertypeBox('investor', "I'm an Investor", 'assets/images/investor.png', 'assets/images/investor_active.png'),
                buildUsertypeBox('startup', "I'm a Founder", 'assets/images/founder.png', 'assets/images/founder_active.png'),
                const SizedBox(height: 10),
                CustomButton(text: 'Continue', onPressed: selectedUsertype != '' ? () => Navigator.of(context).pushNamed('/${selectedUsertype}_setup_profile') : () {},),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
