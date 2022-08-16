import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studently/model/user.dart';
import 'package:studently/screens/tutorScreens/searchResultTutor.dart';
import 'package:studently/services/dataController.dart';

class SearchTutor extends StatefulWidget {
  const SearchTutor({Key? key, required this.tutordata}) : super(key: key);
  final List<Tutors?> tutordata;

  @override
  State<SearchTutor> createState() => _SearchTutorState();
}

class _SearchTutorState extends State<SearchTutor> {
  int group = 1;
  String text = "Search tutor";
  String searchText = "";
  final TextEditingController searchController = TextEditingController();
  late QuerySnapshot snapshotData;
  bool isExecuted = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.clear),
        onPressed: () {
          setState(() {
            isExecuted = false;
            searchController.clear();
          });
        },
        backgroundColor: Colors.green,
      ),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color.fromARGB(255, 244, 244, 244),
        actions: [
          GetBuilder<DataController>(
            init: DataController(),
            builder: (val) {
              return IconButton(
                onPressed: () {
                  searchController.text = searchText.toLowerCase();
                  if (searchController.text == "") {
                    setState(() {
                      isExecuted = false;
                      searchController.clear();
                    });
                    return;
                  }
                  if (text == "Search skills") {
                    val.querySkillsData(searchController.text).then((value) {
                      snapshotData = value;
                      setState(() {
                        isExecuted = true;
                      });
                    });
                  } else {
                    val.queryData(searchController.text).then((value) {
                      snapshotData = value;
                      setState(() {
                        isExecuted = true;
                      });
                    });
                  }
                },
                icon: const Icon(Icons.search),
                color: Colors.green,
              );
            },
          )
        ],
        title: TextField(
          controller: searchController,
          onChanged: (val) {
            searchText = val;
          },
          style: const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
          decoration: InputDecoration(
            hintText: text,
            hintStyle:
                const TextStyle(color: Color.fromARGB(255, 156, 156, 156)),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.green),
            ),
          ),
        ),
      ),
      body: isExecuted
          ? searchedData()
          : Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ListTile(
                  title: Text("tutors"),
                  leading: Radio(
                    value: 1,
                    groupValue: group,
                    onChanged: (value) {
                      setState(() {
                        group = value as int;
                        text = "Search tutors";
                      });
                    },
                    activeColor: Colors.green,
                  ),
                ),
                ListTile(
                  title: Text("skills"),
                  leading: Radio(
                    value: 2,
                    groupValue: group,
                    onChanged: (value) {
                      setState(() {
                        group = value as int;
                        text = "Search skills";
                      });
                    },
                    activeColor: Colors.green,
                  ),
                ),
                Center(
                  child: Text(
                    text,
                    style: TextStyle(
                        color: Color.fromARGB(255, 175, 175, 175),
                        fontSize: 20),
                  ),
                )
              ],
            ),
    );
  }

  Widget searchedData() {
    return ListView.builder(
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
          onTap: () {
            print(snapshotData.docs[index]["uid"].toString());

            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => SearchResultTutor(
                        searchdata: [
                          snapshotData.docs[index],
                        ],
                        tutordata: widget.tutordata,
                      )),
            );
          },
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.grey,
              backgroundImage: NetworkImage(
                snapshotData.docs[index]['photofilepath'],
              ),
              radius: 25,
            ),
            title: Text(
              snapshotData.docs[index]['username'],
              style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 19),
            ),
            subtitle: Text(
              snapshotData.docs[index]['about'],
              style: const TextStyle(
                  color: Color.fromARGB(255, 104, 104, 104), fontSize: 13),
            ),
          ),
        );
      },
      itemCount: snapshotData.docs.length,
    );
  }
}
