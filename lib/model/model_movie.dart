import 'package:cloud_firestore/cloud_firestore.dart';

class Movie{
  final String title;
  final String keyword;
  final String poster;
  bool like;
  //DocumentReference는 실제 firebase firestore에
  // 있는 데이터 컬럼을 참조할 수 있는 링크
  //이 reference를 이용해 해당 데이터에 대한 CRUD 기능을 아주 간단히 처리할 수 있다.
  final DocumentReference reference;

  //Map 값을 받아서 이 클래스를 생성할 수 있는 생성자
  //이름 있는 생성자
  Movie.fromMap(Map<String,dynamic> map, {required this.reference}) :
        title = map['title'],
        keyword = map['keyword'],
        poster = map['poster'],
        like = map['like'];

  //있는 함수가 아닌 새로 만든 함수(생성자)
  Movie.fromSnapshot(DocumentSnapshot snapshot) :
      this.fromMap(snapshot.data(), reference:snapshot.reference);


  @override
  String toString() =>"Movie<$title:$keyword>";
}


