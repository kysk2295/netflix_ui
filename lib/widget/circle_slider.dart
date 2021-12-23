import 'package:flutter/material.dart';
import 'package:untitled1/model/model_movie.dart';
import 'package:untitled1/screen/detail_screen.dart';

//statelesswidget은 state가 없으므로
// state 관리 클래스를 따로 안만들어도 됨.
class CircleSlider extends StatelessWidget{

   final List<Movie> movies;
   CircleSlider({required this.movies});

   
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(7),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('미리보기'),
        Container(
          height: 120,
          child: Container(
            child: ListView(
              //horizontal : 좌우 스크롤 가능
              scrollDirection: Axis.horizontal,
              children: makeCircleImages(context,movies),
            ),
          ),
        )
      ],),
    );
  }
}

List<Widget> makeCircleImages(BuildContext context, List<Movie> movies) {
  List<Widget> results =[];
  
  for(var i=0;i<movies.length;i++)
    {
      results.add(
        InkWell(
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder:
                (context) => DetailScreen(movie: movies[i],)));
            //정보 버튼을 누르면 해당 영화 정보가 인자로 넘어간다.
          },
          child: Container(
            padding: EdgeInsets.only(right: 10),
            child: Align(
              alignment: Alignment.centerLeft,
              child: CircleAvatar(
                backgroundImage: NetworkImage(movies[i].poster),
                radius: 48,
              ),
            ),
          ),
        )
      );
    }

  return results;
}