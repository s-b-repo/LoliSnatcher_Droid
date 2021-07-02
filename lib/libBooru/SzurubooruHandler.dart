import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'Booru.dart';
import 'BooruHandler.dart';
import 'BooruItem.dart';
import 'package:LoliSnatcher/Tools.dart';

class SzurubooruHandler extends BooruHandler{
  SzurubooruHandler(Booru booru,int limit) : super(booru,limit);
  bool tagSearchEnabled = false;

  @override
  String validateTags(tags){
    if (tags == "" || tags == " "){
      return "*";
    } else{
      return tags;
    }
  }
  void parseResponse(response){
    Map<String, dynamic> parsedResponse = jsonDecode(response.body);
    /**
     * This creates a list of xml elements 'post' to extract only the post elements which contain
     * all the data needed about each image
     */
    // Create a BooruItem for each post in the list
    for (int i =0; i < parsedResponse['results'].length; i++){
      if (i == 0){
        print(parsedResponse['results'][0].toString());
      }
      var current = parsedResponse['results'][i];
      List<String> tags = [];
      for (int x=0; x < current['tags'].length; x++) {
        String currentTags = current['tags'][x]['names'].toString().replaceAll(r":", r"\:");
        currentTags = currentTags.substring(1,currentTags.length - 1);
        if (currentTags.contains(",")){
          tags.addAll(currentTags.split(", "));
        } else {
          tags.add(currentTags);
        }
      }
      if(current['contentUrl'] != null){
        fetched.add(new BooruItem(
          fileURL: "${booru.baseURL}/"+current['contentUrl'],
          fileWidth: current['canvasWidth'].toDouble(),
          fileHeight: current['canvasHeight'].toDouble(),
          sampleURL: "${booru.baseURL}/"+current['contentUrl'],
          thumbnailURL: "${booru.baseURL}/"+current['thumbnailUrl'],
          tagsList: tags,
          serverId: current['id'].toString(),
          score: current['score'].toString(),
          postURL: makePostURL(current['id'].toString()),
          rating: current['safety'],
          postDate: current['creationTime'].substring(0,22),
          postDateFormat: "yyyy-MM-dd'T'HH:mm:ss.SSS",
        ));

        if(dbHandler!.db != null){
          setTrackedValues(fetched.length - 1);
        }
      }
    }
  }
  @override
  Map<String,String> getHeaders() {
    if(booru.apiKey!.isNotEmpty){
      return {"Content-Type":"application/json","Accept": "application/json", "user-agent":"LoliSnatcher_Droid/$verStr", "Authorization": "Token " + base64Encode(utf8.encode("${booru.userID}:${booru.apiKey}"))};
    } else {
      return {"Content-Type":"application/json","Accept": "application/json", "user-agent":"LoliSnatcher_Droid/$verStr"};
    }
  }

  // This will create a url to goto the images page in the browser
  String makePostURL(String id){
    return "${booru.baseURL}/post/$id";
  }
  // This will create a url for the http request
  String makeURL(String tags){
    return "${booru.baseURL}/api/posts/?offset=${pageNum*limit}&limit=${limit.toString()}&query=$tags";
    }

  String makeTagURL(String input){
    return "${booru.baseURL}/api/tags/?offset=0&limit=10&query=$input*";
  }
  @override
  Future tagSearch(String input) async {
    List<String> searchTags = [];
    String url = makeTagURL(input);
    try {
      Uri uri = Uri.parse(url);
      final response = await http.get(uri,headers: getHeaders());
      print(response.body);
      // 200 is the success http response code
      if (response.statusCode == 200) {
        Map<String, dynamic> parsedResponse = jsonDecode(response.body);
        if (parsedResponse.length > 0){
          for (int i=0; i < parsedResponse["results"].length; i++){
            String tag = parsedResponse["results"][i]['names'][0].toString().replaceAll(r":", r"\:");;
            searchTags.add(tag);
          }
        }
      }
    } catch(e) {
      print(e);
    }
    print(searchTags.length);
    return searchTags;
  }
  }


