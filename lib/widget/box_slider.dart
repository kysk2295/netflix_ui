import 'package:flutter/material.dart';
import 'package:untitled1/model/model_movie.dart';
import 'package:untitled1/screen/detail_screen.dart';

class BoxSlider extends StatelessWidget{

  final List<Movie> movies;
  BoxSlider({required this.movies});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(7),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('지금 뜨는 콘텐츠'),
          Container(height: 120,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: makeBoxImages(context,movies),
          ),)
        ],
      ),
    );
  }


}

List<Widget> makeBoxImages(BuildContext context,List<Movie> movies) {
  List<Widget> result=[];
  for(var i=0;i<movies.length;i++)
    {
      result.add(InkWell(
        onTap:(){
          Navigator.push(context, MaterialPageRoute(builder:
              (context) => DetailScreen(movie: movies[i],)));
          //정보 버튼을 누르면 해당 영화 정보가 인자로 넘어간다.

        } ,
      child: Container(
        padding: EdgeInsets.only(right: 10),
        child: Align(
        alignment: Alignment.centerLeft,
        child: Image.network(movies[i].poster)),
      ),));
    }
  return result;
}