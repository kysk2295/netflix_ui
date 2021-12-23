import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:untitled1/model/model_movie.dart';
import 'package:untitled1/widget/box_slider.dart';
import 'package:untitled1/widget/carousel_slider.dart';
import 'package:untitled1/widget/circle_slider.dart';

class HomeScreen extends StatefulWidget{
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>{
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  late Stream<QuerySnapshot> streamData;

  @override
  void initState() {
    super.initState();

    streamData = firestore.collection('movie').snapshots();

  }


  //streamData로부터 데이터를 추출하여 위젯으로 만드는 과정
  Widget _fetchData(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: streamData,
      builder: (context, snapshot){
        //데이터를 못가져오면
         if(!snapshot.hasData)
           return LinearProgressIndicator();
        return _buildBody(context,snapshot.data!.docs);

      },
    );
  }
  Widget _buildBody(BuildContext context, List<DocumentSnapshot> snapshot) {

    //map 함수를 통해 데이터를 Movie 모델의 형태로 바꿔주고 이를 리스트 형태로 만듬
    List<Movie> movies = snapshot.map((d) => Movie.fromSnapshot(d)).toList();

    return ListView(children: [
      Stack(children: [
        CarouselImage(movies: movies),
        TopBar(),
      ],),
      CircleSlider(movies: movies),
      BoxSlider(movies: movies),

    ],);
  }

  @override
  Widget build(BuildContext context) {
    return _fetchData(context);
  }



}

class TopBar extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(20,7,20,7),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image.asset('images/bbongflix_logo.png',
          fit: BoxFit.contain,
          height: 25,),
          Container(
            padding: EdgeInsets.only(right: 1),
            child: Text(
              'TV 프로그램',
              style: TextStyle(fontSize: 14),
            ),
          ),
          Container(
            padding: EdgeInsets.only(right: 1),
            child: Text(
              '영화',
              style: TextStyle(fontSize: 14),
            ),
          ),
          Container(
            padding: EdgeInsets.only(right: 1),
            child: Text(
              '내가 찜한 콘텐츠',
              style: TextStyle(fontSize: 14),
            ),
          )
        ],
      ),
    );
  }
}