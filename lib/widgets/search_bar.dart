import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../theme.dart';

class SearchBar extends StatelessWidget {
  final TextEditingController _searchControl = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return TextField(
      style: TextStyle(
        fontSize: 15.0,
        color: theme.primaryColorLight,
      ),
      decoration: InputDecoration(
        contentPadding: EdgeInsets.all(10.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
          borderSide: BorderSide(
            color: theme.primaryColorLight,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: theme.primaryColorLight,

          ),

          borderRadius: BorderRadius.circular(5.0),
        ),
        focusedBorder:  OutlineInputBorder(
          borderSide: BorderSide(
            color: theme.primaryColorLight,

          ),

          borderRadius: BorderRadius.circular(5.0),
        ),
        hintText: "Search Cow by ID",
        suffixIcon:  IconButton(
          hoverColor: Colors.transparent,
          icon: Icon(
            Icons.search,
            color: theme.primaryColorLight,
            size: 30,
          ),
          onPressed: () async {
            print('IconButton pressed ...');

            await showDialog(
                context: context,
                builder: (BuildContext context) {
              return  AlertDialog(
                title: Text('Results', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),),

                actions: <Widget>[
              StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance.collection('Cows').where("CowID",isEqualTo: _searchControl.text).snapshots(),
                  builder: (context,snapshot) {
                  print(snapshot.data);
                  print(snapshot.connectionState);
                  switch(snapshot.connectionState) {
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                  return Center(child: CircularProgressIndicator());
                  case ConnectionState.active:
                  //    return Center(child: CircularProgressIndicator());
                  case ConnectionState.done:
                  if(snapshot.hasError) {
                    return Container(
                      height: 50,
                      width: 50,
                      child:Text('No data found',style: TextStyle(
                        fontSize: 30
                      ),),
                    );
                  }
                  if(snapshot.hasData == false) {
                    return Container(
                      height: 50,
                      width: 50,
                      child:Text('No data found',style: TextStyle(
                          fontSize: 30
                      ),),
                    );

                  }
                  final data = snapshot.data!.docs;
                  print(snapshot.data!.size);
                  return snapshot.data!.size > 0?Container(
                  padding: EdgeInsets.only(top: 5.0,left: 20.0,right: 20.0),
                  height: 250.0,
                  width: MediaQuery.of(context).size.width,


                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: Image.network(
                      "${data[0]!["profilePhotoURL"]}",
                      height: MediaQuery.of(context).size.width,
                      width: MediaQuery.of(context).size.width,
                      fit: BoxFit.cover,
                    ),
                  )
                  ):
                 Container(
                   padding: EdgeInsets.only(top: 5.0,left: 20.0,right: 20.0),
                   height: 250.0,
                   width: MediaQuery.of(context).size.width,
                   child: Image.asset('assets/images/no_cow.png'),

                 );
                  }
                  }
                  ),
                  Container(

                    child: ElevatedButton(
                      child: new Text("OK", style: TextStyle(color: Colors.black),),
                      onPressed: () {
                        Navigator.of(context, rootNavigator: true).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.primaryColorLight,
                      ),
                    ),
                  ),

                ],
              );
            });
          },
        ),
        hintStyle: TextStyle(
          fontSize: 15.0,
          color: Colors.tealAccent[888],
        ),
      ),
      maxLines: 1,
      controller: _searchControl,
    );
  }
}
