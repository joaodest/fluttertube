import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:fluttertube/blocs/favorite_bloc.dart';
import 'package:fluttertube/models/video.dart';
import 'package:fluttertube/screens/video_player.dart';

import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoTile extends StatelessWidget {
  const VideoTile({Key? key, required this.video}) : super(key: key);

  final Video video;

  @override
  Widget build(BuildContext context) {
    final blocFav = BlocProvider.getBloc<FavoriteBloc>();
    Map<String, Video> map = {};

    return GestureDetector(
      onTap: (){
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => VideoPlayer(video: video))
        );
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AspectRatio(
              aspectRatio: 16.0 / 9.0,
              child: Image.network(
                video.thumb!,
                fit: BoxFit.cover,
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(8, 8, 8, 0),
                        child: Text(
                          video.title!,
                          style: TextStyle(color: Colors.white, fontSize: 16),
                          maxLines: 2,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8),
                        child: Text(video.channel!),
                      )
                    ],
                  ),
                ),
                StreamBuilder<Map<String, Video>>(
                    initialData: map,
                    stream: BlocProvider.getBloc<FavoriteBloc>().outFav,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return IconButton(
                            onPressed: () {
                              blocFav.toggleFavorite(video);
                            },
                            icon: Icon(snapshot.data!.containsKey(video.id)
                                ? Icons.star
                                : Icons.star_border),
                        color: Colors.white,
                        iconSize: 22,
                        );
                      } else {
                        return Container(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                          ),
                        );
                      }
                    })
              ],
            )
          ],
        ),
      ),
    );
  }
}
