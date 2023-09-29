import 'package:client/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:client/models/profile.dart';
import 'package:client/models/investor_profile.dart';
import 'package:client/models/startup_profile.dart';
import 'package:appinio_swiper/appinio_swiper.dart';
import 'package:client/widgets/ui/profile_card.dart';
import 'package:client/widgets/ui/swipe_control_buttons.dart';

class HomeScreen extends StatefulWidget {
  final List<InvestorProfileModel>? investorProfiles;
  final List<StartupProfileModel>? startupProfiles;
  final Function updateMatches;

  const HomeScreen({super.key , this.investorProfiles, this.startupProfiles, required this.updateMatches});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AppinioSwiperController _swiperController = AppinioSwiperController();
  Profile? currentProfile;

  @override
  void initState() {
    super.initState();
    _initializeCurrentProfile();
  }

  void _initializeCurrentProfile() {
    if (widget.investorProfiles?.isNotEmpty == true) {
      currentProfile = Profile(
        id: widget.investorProfiles![0].userId,
        name: widget.investorProfiles![0].fullName,
        aiAnalysis: widget.investorProfiles![0].aiAnalysis,
        pictureUrl: widget.investorProfiles![0].profilePictureUrl,
      );
    } else if (widget.startupProfiles?.isNotEmpty == true) {
      currentProfile = Profile(
        id: widget.startupProfiles![0].userId,
        name: widget.startupProfiles![0].companyName,
        aiAnalysis: widget.startupProfiles![0].aiAnalysis,
        pictureUrl: widget.startupProfiles![0].companyLogoUrl,
      );
    }
  }

  void _updateCurrentProfile(bool isInvestor, int index) {
    if (isInvestor && index < widget.investorProfiles!.length && widget.investorProfiles?.isNotEmpty == true) {
      Profile newProfile = Profile(
        id: widget.investorProfiles![index].userId ?? index,
        name: widget.investorProfiles![index].fullName,
        aiAnalysis: widget.investorProfiles![index].aiAnalysis,
        pictureUrl: widget.investorProfiles![index].profilePictureUrl,
      );
      
      setState(() {
        currentProfile = newProfile;
      });
      
      } else if (!isInvestor && index < widget.startupProfiles!.length && widget.startupProfiles?.isNotEmpty == true) {
        Profile newProfile = Profile(
          id: widget.startupProfiles![index].userId ?? index,
          name: widget.startupProfiles![index].companyName,
          aiAnalysis: widget.startupProfiles![index].aiAnalysis,
          pictureUrl: widget.startupProfiles![index].companyLogoUrl,
      );
      
      setState(() {
        currentProfile = newProfile;
      });
    }
  }

  void swipeLeft() {
    _swiperController.swipeLeft();
  }

  void swipeRight() {
    _swiperController.swipeRight();
  }

  void onSwipeRight(AppinioSwiperDirection direction, index, bool isInvestor) async {
    if (isInvestor && index <= widget.investorProfiles!.length) {
      ApiService.swipedRight(widget.investorProfiles![index - 1].userId!);
    } else if (!isInvestor && index <= widget.startupProfiles!.length) {
      ApiService.swipedRight(widget.startupProfiles![index - 1].userId!);
    }
  }

  void refreshPotentialMatches() {
    widget.updateMatches();
  }

  @override
  Widget build(BuildContext context) {
    final bool isInvestor = widget.investorProfiles?.isNotEmpty == true;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
        ),
        title: Text(
          isInvestor ? 'Investors' : 'Startups',
          style: const TextStyle(
            color: Color.fromARGB(255, 61, 78, 129),
            fontWeight: FontWeight.bold,
            fontSize: 20,
            fontFamily: 'Montserrat',
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          refreshPotentialMatches();
        },
        child: Container(
          width: double.infinity,
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height,
          ),
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 90),
          child: widget.investorProfiles?.isNotEmpty == true || widget.startupProfiles?.isNotEmpty == true ?
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: AppinioSwiper(
                  padding: const EdgeInsets.only(bottom: 17),
                  cardsCount: isInvestor ? widget.investorProfiles!.length : widget.startupProfiles!.length,
                  cardsSpacing: 40,
                  backgroundCardsCount: 1,
                  controller: _swiperController,
                  onSwipe: (index, direction) {
                    onSwipeRight(direction, index, isInvestor);
                    _updateCurrentProfile(isInvestor, index);
                  },
                  cardsBuilder: (context, index) {
                    return _buildProfileCards(isInvestor, index);
                  },
                ),
              ),
              SwipeControlButtons(leftButton: swipeLeft, rightButton: swipeRight, currentProfile: currentProfile),
            ],
          ) : const Center(
            child: Text('No Profiles Found, Please try again later',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            )
          ),
        ),
      ),
    );
  }

  Widget _buildProfileCards(bool isInvestor, int index) {
    if (isInvestor && index <= widget.investorProfiles!.length) {
      return ProfileCard(investorProfile: widget.investorProfiles![index]);
    }
    else if (!isInvestor && index <= widget.startupProfiles!.length) {
      return ProfileCard(startupProfile: widget.startupProfiles![index]);
    }
    else if (index == widget.investorProfiles!.length || index == widget.startupProfiles!.length) {
      return const Center(
        child: Text('No Profiles Found, Please try again later',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      );
    } else {
      return const Center(
        child: Text('No Profiles Found, Please try again later',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      );
    }
  }
}
