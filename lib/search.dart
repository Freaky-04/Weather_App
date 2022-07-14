import 'package:flutter/material.dart';


class SearchUser extends SearchDelegate{

  @override
  List<Widget>? buildActions(BuildContext context) {
    return[
      IconButton(onPressed: (){
        query ="";
      }, icon: Icon(Icons.close),)
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(onPressed: (){
      Navigator.pop(context);
    }, icon: Icon(Icons.arrow_back_ios),);
  }

  @override
  Widget buildResults(BuildContext context) {
    return (
        Center(child: Text("Search City"),)
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return  Container(
      color: Colors.black.withOpacity(0.5),
    );
  }

}