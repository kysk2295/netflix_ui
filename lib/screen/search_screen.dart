import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:untitled1/model/model_movie.dart';
import 'package:untitled1/screen/detail_screen.dart';

class SearchScreen extends StatefulWidget{
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen>{

  //TextEdit 위젯을 컨트롤하는 위젯
  //앞에 _를 붙이면 private 변수, 생성자에서 접근 가능
  final TextEditingController _filter = TextEditingController();
  //현재 검색 위젯이 커서가 있는지에 대한 상태를 가지고 있는 위젯
  FocusNode focusNode = FocusNode();
  //현재 겁색 값
  String _searchText="";


  //_filter가 상태변화를 감지하여 searchText의 상태를 변화시키는 코드드
 _SearchScreenState(){
    _filter.addListener(() {
      setState(() {
        _searchText=_filter.text;
      });
    });
  }
  //스트림데이터를 가져와 buildList를 호출한다.
  Widget _buildBody(BuildContext context){
   return StreamBuilder<QuerySnapshot>(builder: (context,snapshot){
     //데이터가 없다면
      if(!snapshot.hasData)
        return LinearProgressIndicator();
      //데이터가 있으면
      return _buildList(context,snapshot.data!.docs);
   }, stream: FirebaseFirestore.instance.collection('movie').snapshots(),);
  }
  //검색결과에 따라 데이터를 처리해 Gridview를 생성한다.
  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot){
   List<DocumentSnapshot> searchResults=[];
   //snapshot은 각 도큐먼트들
    for(DocumentSnapshot d in snapshot){
      //검색어를 가지고 있다면
      if(d.data().toString().contains(_searchText)){
        searchResults.add(d);

      }
    }
    return Expanded(child:
        //cressAxisCount : 3 은 한줄에 3칸을 나오게 한다.
    GridView.count(crossAxisCount: 3,
    childAspectRatio: 1/1.5,
    padding: EdgeInsets.all(3),
    //map함수 : docs를 foreach 한다. (한번씩 돈다)
    children: searchResults.map((data) => _buildListItem(context,data)).toList()));
  }
  //각 Gridview에 들어갈 아이템들은  _buildListitem으로 만들고
  // 각각 DetailScreen을 띄운다.
  Widget _buildListItem(BuildContext context,DocumentSnapshot data)
  {
    //데이터를 movie형태로 바꾼다.
    final movie = Movie.fromSnapshot(data);
    return InkWell(
      child: Image.network(movie.poster),
      onTap: (){
        Navigator.of(context).push(MaterialPageRoute<Null>(builder: (BuildContext context){
          return DetailScreen(movie: movie);
        }, fullscreenDialog: true));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
   return Container(
     child: Column(
       children: [
        Padding(padding: EdgeInsets.fromLTRB(30,0,30,30)),
         Container(
             color: Colors.black,
             padding: EdgeInsets.fromLTRB(5, 10, 5, 10),
             child: Row(
               children: [
                 //Expanded 위젯으로 감싸면 텍스트가 넘쳐도 개행이 된다.
                 Expanded(child:
                 TextField(focusNode: focusNode,style:
                   TextStyle(fontSize: 15),autofocus:true ,
                 controller: _filter,
                 decoration: InputDecoration(
                   filled: true,
                   fillColor: Colors.white12,
                   //앞에 붙을 아이콘
                   prefixIcon: Icon(
                     Icons.search,
                     color: Colors.white60,
                     size: 20,
                   ),
                     //뒤에 붙을 아이콘
                     //커서가 있을때 x 버튼을 띄우고 아니라면 빈 상태로 보여준다.
                     suffixIcon: focusNode.hasFocus ? IconButton(onPressed: (){
                       setState(() {
                         _filter.clear();
                         _searchText="";
                       });
                     },
                     icon: Icon(Icons.cancel, size: 20,
                     color: Colors.white,)): Container(),
                     hintText: '검색',
                     labelStyle: TextStyle(color: Colors.white60),
                     focusedBorder: OutlineInputBorder(
                       borderSide: BorderSide(color: Colors.transparent),
                       borderRadius: BorderRadius.all(Radius.circular(10)),
                     ),
                     enabledBorder: OutlineInputBorder(
                       borderSide: BorderSide(color: Colors.transparent),
                       borderRadius: BorderRadius.all(Radius.circular(10)),
                     ),
                     border: OutlineInputBorder(
                       borderSide: BorderSide(color: Colors.transparent),
                       borderRadius: BorderRadius.all(Radius.circular(10)),
                     )
                     //flex : 공간을 차지하는 비율
                 ),), flex: 6),
                 focusNode.hasFocus ? Expanded(child:
                 FlatButton(onPressed: () {
                   setState(() {
                     _filter.clear();
                     _searchText="";
                     focusNode.unfocus();
                   });
                 },
                 child: Text('취소', style: TextStyle(fontSize: 10),) ,)) : Expanded(child: Container(),
                 flex: 0,)
               ],
             ),
           ),
      _buildBody(context)
       ],
     ),
   );
  }
}