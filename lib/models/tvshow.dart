//region LISTS


import 'package:eWoke/constants/custom_variables.dart';

class AllTVShowList{
  final List showList;


  AllTVShowList({ this.showList});

  factory AllTVShowList.fromJson(List <dynamic> json){
    List<dynamic> showList = new List<dynamic>();
//    print("data: $json");
//    showList.clear();
    json.forEach((element) {
      showList.add(TVShow.fromJson(element['show']));
      // print("Added");
    });

//    print("first: ${showList[0].name}");

    return AllTVShowList(
      showList: showList
    );
  }
}
//endregion

class TVShow{
  String id;
  String name;
  String language;
  String type;
  List<dynamic> genres;
  String startDate;
  dynamic rating;
  String updated;
  String status;
  String imageThumbnailPath;
  dynamic runtime;
  String summary;

  TVShow({
      this.id,
      this.name,
      this.language,
      this.type,
      this.genres,
      this.startDate,
      this.rating,
      this.updated,
      this.status,
      this.runtime,
      this.summary,
      this.imageThumbnailPath});

  factory TVShow.fromJson(Map <String, dynamic> json){

    // print(json['name']);
    return TVShow(
        id : json['id'].toString(),
        name : json['name'] ?? "",
        type: json['type'] ?? "",
        language: json['language'] ?? "",
      runtime: json['runtime']!= null  ? json['runtime'] : 0,
      summary: json['summary'] ?? "",
        genres: json['genres'].length > 0 ? json['genres'] : ['N/A'],
        startDate : json['premiered'] ?? "",
        rating : json['rating']['average'] == null ? 0.0 : json['rating']['average'] ,
        updated: json['updated'].toString(),
        status : json['status'],
        imageThumbnailPath : json['image'] != null ? json['image']['medium']: GlobalVariables.PLACEHOLDER_IMAGE, // MEDIUM IMAGE
      );
    }

  @override
  String toString() {
    return 'TVShow{id: $id, name: $name, language: $language, type: $type, genres: $genres, startDate: $startDate, rating: $rating, updated: $updated, status: $status, imageThumbnailPath: $imageThumbnailPath, runtime: $runtime, summary: $summary}';
  }
}




