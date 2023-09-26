import 'package:flutter/material.dart';
import 'package:client/models/startup_profile.dart';
import 'package:client/models/investor_profile.dart';
import 'package:appinio_video_player/appinio_video_player.dart';


class ProfileCard extends StatefulWidget {
  final InvestorProfileModel? investorProfile;
  final StartupProfileModel? startupProfile;

  const ProfileCard({super.key, this.investorProfile, this.startupProfile});

  @override
  State<ProfileCard> createState() => _ProfileCardState();
}

class _ProfileCardState extends State<ProfileCard> {

  @override
  Widget build(BuildContext context) {
    final isInvestor = widget.investorProfile != null;
    final industriesCount = isInvestor ? 0 : widget.startupProfile!.industries.length;
    final visualContent = isInvestor ? widget.investorProfile!.profilePictureUrl : widget.startupProfile!.pitchVideoUrl;

    return Container(
      height: double.infinity,
      padding: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        color: const Color.fromARGB(255, 62, 79, 129),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            height: isInvestor ? MediaQuery.of(context).size.height * 1 / 2.85 : MediaQuery.of(context).size.height * 1 / 4.5,
            width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(20)),
                color: Colors.black45,
                image: isInvestor ? DecorationImage(
                  image: NetworkImage(widget.investorProfile!.profilePictureUrl),
                  fit: BoxFit.cover,
                ) : null,
              ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(20)),
                gradient: isInvestor ? LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: const [0.75, 1],
                  colors: isInvestor ? [Colors.transparent, Colors.black87] : [Colors.transparent, Colors.transparent, Colors.black54],
                ) : null,
              ),
              child: isInvestor
                  ? Padding(
                    padding: const EdgeInsets.only(bottom: 10, left: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        BuildName(isInvestor: isInvestor, widget: widget),
                      ],
                    ),
                  )
                  : CustomVideoPlayer(videoUrl: visualContent),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
            child: Column(
              children: [
                if (!isInvestor)
                Row(
                  children: [
                    CircleAvatar(
                      radius: 25,
                      backgroundColor: Colors.black26,
                      backgroundImage: NetworkImage( isInvestor ? widget.investorProfile!.profilePictureUrl : widget.startupProfile!.companyLogoUrl),
                      onBackgroundImageError: (exception, stackTrace) => const Icon(Icons.person),
                      child: widget.startupProfile != null && widget.startupProfile!.companyLogoUrl.isEmpty ? const Icon(Icons.person) : null,
                    ),
                    const SizedBox(width: 10),
                    BuildName(isInvestor: isInvestor, widget: widget),
                  ],
                ),
                if (!isInvestor)
                ...[const SizedBox(height: 12),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                        color: Colors.white,
                      ),
                      child: Text(
                        industriesCount > 2 ? '${widget.startupProfile!.industries[0]}, ${widget.startupProfile!.industries[1]}, ...' : widget.startupProfile!.industries.join(', '),
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                        color: Color.fromRGBO(0, 0, 0, 0.5),
                      ),
                      child: Text(
                        widget.startupProfile!.investmentStage,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                )],
                if (!isInvestor)
                const SizedBox(height: 14),
                Text(
                  isInvestor ? widget.investorProfile!.bio : widget.startupProfile!.companyDescription,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class BuildName extends StatelessWidget {
  const BuildName({
    super.key,
    required this.isInvestor,
    required this.widget,
  });

  final bool isInvestor;
  final ProfileCard widget;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          isInvestor ? widget.investorProfile!.fullName : widget.startupProfile!.companyName,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          isInvestor ? widget.investorProfile!.location : widget.startupProfile!.location,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}

class CustomVideoPlayer extends StatefulWidget {
  final String videoUrl;

  const CustomVideoPlayer({super.key, required this.videoUrl});

  @override
  _CustomVideoPlayerState createState() => _CustomVideoPlayerState();
}

class _CustomVideoPlayerState extends State<CustomVideoPlayer> {
  late VideoPlayerController _videoPlayerController;
  late Future<void> _initializeVideoPlayerFuture; 

  @override
  void initState() {
    super.initState();
    _videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl));
      _initializeVideoPlayerFuture = _videoPlayerController.initialize().then((_) {
        _videoPlayerController.play();
        _videoPlayerController.setLooping(true);
        setState(() {});
      });
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initializeVideoPlayerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(20)),
            child: AspectRatio(
              aspectRatio: _videoPlayerController.value.aspectRatio,
              child: VideoPlayer(_videoPlayerController),
            ),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
