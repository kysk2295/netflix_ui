import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:untitled1/model/model_movie.dart';
import 'package:untitled1/screen/detail_screen.dart';

//widget 관리
//데이터를 외부에서 접근하려면 이 클래스에다가 넣어줘야 함
class CarouselImage extends StatefulWidget{
  final List<Movie> movies;

  //생성자 이용해서 값 초기화
  CarouselImage({required this.movies});
  _CarouselImageState createState() => _CarouselImageState();

}

//state 관리
class _CarouselImageState extends State<CarouselImage> {
  late List<Movie> movies;
  late List<Widget> images;
  late List<String> keywords;
  late List<bool> likes;

  int _currentPage=0;
  late String _currentkeyowrd;
  
  @override
  void initState() {
    super.initState();
    movies=widget.movies;
    //.map 메서드는 iterable을 foreach한 후 리스트로 만들어 준다.
    images=movies.map((m) => Image.network(m.poster)).toList();
    keywords=movies.map((m) => m.keyword).toList();
    likes=movies.map((m) => m.like).toList();
    _currentkeyowrd=keywords[0];



  }

  @override
  Widget build(BuildContext context) {

    setState(() {
      FirebaseFirestore.instance
          .collection('movie')
          .doc().snapshots()
          .listen((event) {
        likes=event.data()['like'];
      });

      print('hi :'+likes[_currentPage].toString());

    });

    return Container(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(20),
            ),
            CarouselSlider(items: images, options: CarouselOptions(
              onPageChanged: (index,reason){
                setState(() {
                  _currentPage=index;
                  _currentkeyowrd=keywords[_currentPage];
                });
              }
            )),
            Container(
              padding: EdgeInsets.fromLTRB(0, 10, 0, 3),
              child: Text(_currentkeyowrd,
              style: TextStyle(fontSize: 11),),
            ),
            Container(child:
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(child: Column(
                  children: [
                    likes[_currentPage] ?
                        IconButton(onPressed: (){
                          //like 버튼을 누르면
                          setState(() {
                            likes[_currentPage] = !likes[_currentPage];
                            movies[_currentPage].reference.update(
                              {'like':likes[_currentPage]}
                            );
                            movies[_currentPage].like=likes[_currentPage];

                          });
                        }, icon: Icon(Icons.check)) :
                        IconButton(onPressed: (){
                          likes[_currentPage] = !likes[_currentPage];
                          movies[_currentPage].reference.update(
                              {'like':likes[_currentPage]}
                          );
                          movies[_currentPage].like=likes[_currentPage];
                          print(movies[_currentPage].like);

                        }, icon: Icon(Icons.add)),
                    Text("내가 찜한 콘텐츠",style: TextStyle(fontSize: 11),)
                  ],
                ),),
                Container(
                  padding: EdgeInsets.only(right: 10),
                  child: FlatButton(
                    color: Colors.white,
                    onPressed: (){},
                    child: Row(
                      children: [
                        Icon(Icons.play_arrow, color: Colors.black,),
                        Padding(padding: EdgeInsets.all(3)), 
                        Text("재생",style: TextStyle(color: Colors.black),)

                      ],
                    ),

                    ),
                  ),

                Container(padding: EdgeInsets.only(right: 10),
                child: Column(
                  children: [
                    IconButton(onPressed: (){
                      print(movies[_currentPage].title);
                      print(_currentPage);

                      Navigator.push(context, MaterialPageRoute(builder:
                      (context) => DetailScreen(movie: movies[_currentPage],)));
                        //정보 버튼을 누르면 해당 영화 정보가 인자로 넘어간다.

                    }, icon: Icon(Icons.info)),
                    Text("정보",style:TextStyle(fontSize: 11) ,)
                  ],
                ),)

              ],
            ),),
            Container(child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: makeIndicator(likes, _currentPage),
            ),)
          ],
        ) ,
      );
  }
}

List<Widget> makeIndicator(List list, int _currentPage){
  List<Widget> results=[];
  for(var i=0;i<list.length;i++)
    {
      results.add(Container(
        width: 8,
        height: 8,
        margin: EdgeInsets.symmetric(vertical: 10.0,horizontal: 2.0),
        decoration: BoxDecoration(shape: BoxShape.circle, color: _currentPage == i
            ? Color.fromRGBO(255, 255, 255, 0.9)
        : Color.fromRGBO(255, 255, 255, 0.4)),
      ));
    }
  return results;
}