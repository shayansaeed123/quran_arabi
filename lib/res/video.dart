import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({required this.videolink});
  String videolink;
  @override
  State<HomeScreen> createState() => _HomeScreenState(videolink: videolink);
}

class _HomeScreenState extends State<HomeScreen> {
  _HomeScreenState({required this.videolink});
  String videolink;
  
  // YT Controller
  // late YoutubePlayerController _youtubePlayerController;

  // Video Title
  late String videoTitle;

  // Url List
  final List<String> _videoUrlList = [
    'https://www.youtube.com/watch?v=YE7VzlLtp-4',
    
  ];

  /*
  YoutubePlayerController _ytFN({String? url}) {
    return YoutubePlayerController(
      initialVideoId: YoutubePlayer.convertUrlToId(url!)!,
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        enableCaption: true,
      ),
    );
  }

  //
  @override
  void initState() {
    ytFN(url: videoUrlList.first);
    super.initState();
  }

  //
  @override
  void dispose() {
    _ytFN().dispose();
    _youtubePlayerController.dispose();
    super.dispose();
  }
*/
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(color: Colors.cyan,),
        backgroundColor: Color.fromARGB(199, 52, 52, 52),
        // title: const Text('Tubeloid'),
        // centerTitle: true,
        // actions: [
        //   IconButton(
        //     onPressed: () {},
        //     icon: const Icon(Icons.menu_outlined),
        //   )
        // ],
      ),
      backgroundColor: Color.fromARGB(199, 52, 52, 52),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: ListView.builder(
              itemCount: 1,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                final _ytController = YoutubePlayerController(
                  initialVideoId:
                      YoutubePlayer.convertUrlToId(videolink==""?"":videolink)!,
                  flags: const YoutubePlayerFlags(
                    autoPlay: false,
                    enableCaption: true,
                    captionLanguage: 'en',
                  ),
                );
                bool _isPlaying = false;
                return Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height*0.40,
                      decoration: const BoxDecoration(
                        // color: Color(0xfff5f5f5),
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                      ),
                      child: ClipRRect(
                        borderRadius: const BorderRadius.all(Radius.circular(12)),
                        child: YoutubePlayer(
                          controller: _ytController
                            ..addListener(() {
                              if (_ytController.value.isPlaying) {
                                setState(() {
                                  _isPlaying = true;
                                });
                              } else {
                                _isPlaying = false;
                              }
                            }),
                          showVideoProgressIndicator: true,
                          progressIndicatorColor: Colors.blue,
                          progressColors: ProgressBarColors(backgroundColor: Colors.black),
                          bottomActions: [
                            CurrentPosition(),
                            ProgressBar(isExpanded: true),
                            FullScreenButton(),
                          ],
                          onEnded: (YoutubeMetaData _md) {
                            _ytController.reset();
                            _md.videoId;
                            print(_md.title);
                          },
                        ),
                      ),
                    ),
                    _isPlaying
                        ? Container()
                        : Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              // color: Colors.white.withOpacity(0.9),
                              borderRadius: const BorderRadius.only(
                                bottomRight: Radius.circular(12),
                                bottomLeft: Radius.circular(12),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                _ytController.metadata.title,
                                style: const TextStyle(
                                  fontSize: 20.0,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}