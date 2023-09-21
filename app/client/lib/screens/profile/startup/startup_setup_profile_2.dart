import 'dart:async';
import 'package:client/widgets/input_fields.dart';
import 'package:client/widgets/custom_buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:client/models/startup_profile.dart';
import 'dart:io';

class StartupSetupProfileScreen2 extends StatefulWidget {
  const StartupSetupProfileScreen2({Key? key}) : super(key: key);

  @override
  _StartupSetupProfileScreen2State createState() => _StartupSetupProfileScreen2State();
}

class _StartupSetupProfileScreen2State extends State<StartupSetupProfileScreen2> {
  StartupProfileModel? startupData;
  String buttonText = 'Continue';
  String? _thumbnailPath;
  File videoFile = File('');
  String descriptionInputValue = '';
  String? errorMessage;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    startupData = ModalRoute.of(context)?.settings.arguments as StartupProfileModel?;
  }

  Future<void> _pickVideo() async {
    final picker = ImagePicker();
    final selectedVideo = await picker.pickVideo(source: ImageSource.gallery);

    if (selectedVideo != null) {
      videoFile = File(selectedVideo.path);

      VideoPlayerController controller = VideoPlayerController.file(videoFile);
      await controller.initialize();
      final videoDuration = controller.value.duration;

      if (videoDuration.inSeconds > 60) {
        setState(() {
          errorMessage = 'Video must be 60 seconds or less';
        });

        Timer(const Duration(seconds: 8), () {
          setState(() {
            errorMessage = null;
          });
        });

        controller.dispose();
        return;
      }

      final thumbnail = await VideoThumbnail.thumbnailFile(
        video: videoFile.path,
        imageFormat: ImageFormat.PNG,
        maxHeight: 200,
        quality: 50,
      );

      setState(() {
        _thumbnailPath = thumbnail;
      });
    }
  }

  void handleFormSubmit() {
    if (descriptionInputValue.isEmpty || videoFile.path.isEmpty) {
      setState(() {
        buttonText = 'Please fill in all fields';
      });

      Timer(const Duration(seconds: 2), () {
        setState(() {
          buttonText = 'Continue';
        });
      });

      return;
    }
    startupData?.pitchVideoFile = videoFile;
    startupData?.companyDescription = descriptionInputValue;
    Navigator.of(context).pushNamed('/startup_setup_profile_3', arguments: startupData);
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Container(
            width: double.infinity,
            padding: const EdgeInsets.only(right: 25),
            child: const Text(
              '2/3',
              textAlign: TextAlign.end,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w500,
                fontSize: 18,
              ),
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
        body: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                InkWell(
                  onTap: _pickVideo,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: double.infinity,
                        height: 170,
                        color: _thumbnailPath != null ? null : Colors.grey[200],
                        child: _thumbnailPath != null
                            ? Image.file(
                                File(_thumbnailPath!),
                                fit: BoxFit.contain,
                              )
                            : const SizedBox(),
                      ),
                      if (_thumbnailPath == null)
                        const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.cloud_upload, size: 60, color: Colors.grey),
                            SizedBox(height: 8),
                            Text(
                              'Upload your Pitch Video',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      if (_thumbnailPath != null)
                        Container(
                          width: double.infinity,
                          height: 170,
                          color: Colors.black.withOpacity(0.3),
                          child: const Icon(
                            Icons.cloud_upload,
                            size: 60,
                            color: Colors.white,
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (errorMessage != null)
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Text(
                            errorMessage!,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 17,
                              fontWeight: FontWeight.w500
                            ),
                          ),
                        ),
                    const Text(
                      'Video Guidelines',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      '- Keep the video between 30 seconds and 1 minute.',
                      style: TextStyle(
                        fontSize: 16,
                        color: Color.fromARGB(255, 117, 117, 117),
                      ),
                    ),
                    const SizedBox(height: 2),
                    const Text(
                      '- Clearly explain your startup\'s mission and vision.',
                      style: TextStyle(
                        fontSize: 16,
                        color: Color.fromRGBO(117, 117, 117, 1),
                      ),
                    ),
                    const SizedBox(height: 2),
                    const Text(
                      '- Highlight your product or service.',
                      style: TextStyle(
                        fontSize: 16,
                        color: Color.fromRGBO(117, 117, 117, 1),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                InputField(
                  maxLines: 5,
                  label: const Text(
                    'Description',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  maxCharacterCount: 260,
                  hint: 'Describe your startup in 260 characters or less (Recommended length: 200-240 characters)',
                  onInputChanged: (value) {
                    descriptionInputValue = value;
                  },
                ),
                const SizedBox(height: 5),
                const Text(
                  'Your video and description are critical. They are the first things potential investors will see.',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),
                CustomButton(text: buttonText, onPressed: handleFormSubmit),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
