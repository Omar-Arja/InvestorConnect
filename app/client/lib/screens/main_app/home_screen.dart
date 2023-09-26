import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:appinio_swiper/appinio_swiper.dart';
import 'package:client/widgets/ui/profile_card.dart';
import 'package:client/widgets/ui/home_buttons.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final AppinioSwiperController _swiperController = AppinioSwiperController();

  void swipeLeft() {
    _swiperController.swipeLeft();
  }

  void swipeRight() {
    _swiperController.swipeRight();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
        ),
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'All',
              style: TextStyle(
                color: Color.fromARGB(255, 61, 78, 129),
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.underline,
                fontSize: 20,
                fontFamily: 'Montserrat',
              ),
            ),
            SizedBox(width: 8),
            Text(
              'Matched',
              style: TextStyle(
                color: Color.fromARGB(90, 62, 79, 129),
                fontWeight: FontWeight.bold,
                fontSize: 20,
                fontFamily: 'Montserrat',
              ),
            ),
          ],
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Container(
        width: double.infinity,
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height,
        ),
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 90),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: AppinioSwiper(
                padding: const EdgeInsets.only(bottom: 17),
                cardsCount: 10,
                loop: true,
                cardsSpacing: 40,
                backgroundCardsCount: 1,
                controller: _swiperController,
                cardsBuilder: (context, index) => ProfileCard(),
              ),
            ),
            HomeButtons(leftButton: swipeLeft, rightButton: swipeRight),
          ],
        ),
      ),
    );
  }
}
