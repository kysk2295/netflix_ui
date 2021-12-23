import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:untitled1/screen/home_screen.dart';
import 'package:untitled1/screen/like_screen.dart';
import 'package:untitled1/screen/more_screen.dart';
import 'package:untitled1/screen/search_screen.dart';
import 'package:untitled1/widget/bottom_bar.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}
class MyApp extends StatefulWidget{
  _MyAppState createState()=>_MyAppState();
}

class _MyAppState extends State<MyApp>{


  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: "NetFlix", theme: ThemeData(brightness: Brightness.dark,
    primaryColor: Colors.black,
    accentColor: Colors.white
    ), home: DefaultTabController(length: 4,
        child: Scaffold(
            body: TabBarView(
              //NeverScrollableScrollPhysics : 사용자가 직접 스크롤해서 넘기는걸 막겠다.
            physics: NeverScrollableScrollPhysics(),
              children: [
               HomeScreen(),
                SearchScreen(),
               LikeScreen(),
                MoreScreen()
              ],
    ),
        bottomNavigationBar: BottomBar())
    ),);
  }
}