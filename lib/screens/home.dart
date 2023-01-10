import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:fluttertube/blocs/favorite_bloc.dart';
import 'package:fluttertube/blocs/videos_bloc.dart';
import 'package:fluttertube/delegate/data_search.dart';
import 'package:fluttertube/models/video.dart';
import 'package:fluttertube/screens/favorites.dart';
import 'package:fluttertube/widget/video_tile.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final bloc = BlocProvider.getBloc<VideosBloc>();
    Map<String, Video> map = {};

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Container(
          height: 60,
          child: Image.asset("images/ytb_logo.png"),
        ),
        elevation: 0,
        backgroundColor: Color(0xff202020),
        actions: [
          Align(
            alignment: Alignment.center,
            child: StreamBuilder<Map<String, Video>>(
              stream: BlocProvider.getBloc<FavoriteBloc>().outFav,
              builder: (context, snapshot){
                if(snapshot.hasData){
                  return Text("${snapshot.data!.length}");
                } else {
                  return Container();
                }
              },
            ),
          ),
          IconButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const Favorites())
                );
          },
              icon: const Icon(Icons.star)
          ),
          IconButton(
              onPressed: () async {
                String? result = await showSearch(context: context, delegate: DataSearch());
                if(result != null){
                  bloc.inSearch.add(result);
                }
          },
              icon: const Icon(Icons.search),
          ),
        ],
      ),
      body: StreamBuilder(
        initialData: map,
        stream: BlocProvider.getBloc<VideosBloc>().outVideos,
        builder: (BuildContext context, AsyncSnapshot snapshot){
          if(snapshot.hasData){
            return ListView.builder(
              itemCount: snapshot.data.length + 1,
              itemBuilder: (context, index){
                  if(index < snapshot.data.length){
                    return VideoTile(video: snapshot.data[index]);
                  } else if (index > 1){
                    bloc.inSearch.add(null);
                    return Container(
                      height: 40,
                      width: 40,
                      alignment: Alignment.center,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.red)),
                    );
                  } else {
                    return Container();
                  }
              },
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }
}
