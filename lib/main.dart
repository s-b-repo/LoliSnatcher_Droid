import 'package:flutter/material.dart';
import 'libBooru/GelbooruHandler.dart';
import 'libBooru/MoebooruHandler.dart';
import 'libBooru/DanbooruHandler.dart';
import 'libBooru/BooruHandler.dart';
import 'libBooru/BooruItem.dart';
void main() {
  runApp(MaterialApp(
    home: Home(),
  ));
}

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Loli Snatcher"),
      ),
      body: Center(
        child: Images("kanna_kamui"),

      ),
    );
  }

}
/**
 * This widget will create a booru handler and then generate a gridview of preview images using a future builder and the search function of the booru handler
 */
Widget Images(String tags){
  BooruHandler test = new DanbooruHandler("https://danbooru.donmai.us", 100);
  return FutureBuilder(
      future: test.Search(tags),
      builder: (context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        } else {
          return GridView.builder(
            itemCount: snapshot.data.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2),
            itemBuilder: (BuildContext context, int index) {
              return new Card(
                child: new GridTile(
                  // Inkresponse is used so the tile can have an onclick function
                  child: new InkResponse(
                    enableFeedback: true,
                    child:new Image.network('${snapshot.data[index].thumbnailURL}',fit: BoxFit.cover,),
                    onTap: () => printInfo(snapshot.data[index],index),
                  ),
                ),
              );
            },
          );
        }
      });
}

// Fucntion to test on click functionality of the grid tiles
void printInfo(BooruItem item, int index){
  print(item.fileURL);
}
