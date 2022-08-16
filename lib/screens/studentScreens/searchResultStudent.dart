import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tags/flutter_tags.dart';
import 'package:studently/model/user.dart';
import 'package:studently/screens/studentScreens/chat_detailsStudente.dart';

class SearchResultStudent extends StatefulWidget {
  const SearchResultStudent(
      {Key? key, required this.searchdata, required this.studentdata})
      : super(key: key);
  final List<DocumentSnapshot<Object?>> searchdata;
  final List<Students?> studentdata;

  @override
  State<SearchResultStudent> createState() => SsearchResultStudentState();
}

class SsearchResultStudentState extends State<SearchResultStudent> {
  final GlobalKey<TagsState> _skillsTagKey = GlobalKey<TagsState>();
  final GlobalKey<TagsState> _languagesTagKey = GlobalKey<TagsState>();

  bool loading = false;
  List skillsTag = [];
  List languagesTag = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    setState(() {
      widget.searchdata[0]["skills"].forEach((item) {
        skillsTag.add(Item(title: item));
      });

      widget.searchdata[0]["languages"].forEach((item) {
        languagesTag.add(Item(title: item));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.searchdata[0]["username"].toString(),
          style: const TextStyle(
            letterSpacing: 1,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.green,
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 0,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ChatDetailsStudente(
                      friendUserId: widget.searchdata[0]["uid"].toString(),
                      friendFullName:
                          widget.searchdata[0]["username"].toString(),
                      friendProfilePhoto:
                          widget.searchdata[0]["photofilepath"].toString(),
                      studentedata: widget.studentdata,
                    )),
          );
        },
        child: const Icon(Icons.message),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(30, 10, 30, 0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Center(
            child: CircleAvatar(
              backgroundImage: NetworkImage(
                  widget.searchdata[0]["photofilepath"].toString()),
              radius: 50,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Center(
            child: Text(
              widget.searchdata[0]["name"].toString(),
              style: const TextStyle(
                color: Color.fromARGB(255, 9, 9, 9),
                letterSpacing: 1,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          const Text(
            "User Information",
            style: TextStyle(
              color: Color.fromARGB(255, 9, 9, 9),
              letterSpacing: 1,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            widget.searchdata[0]["about"].toString(),
            style: const TextStyle(
              color: Color.fromARGB(255, 9, 9, 9),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          const Text(
            "Skills",
            style: TextStyle(
              color: Color.fromARGB(255, 9, 9, 9),
              letterSpacing: 1,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Tags(
            key: _skillsTagKey,
            itemCount: skillsTag.length,
            columns: 6,
            itemBuilder: (index) {
              final Item currentItem = skillsTag[index];

              return ItemTags(
                index: index,
                title: currentItem.title,
                customData: currentItem.customData,
                textStyle: TextStyle(fontSize: 15),
                combine: ItemTagsCombine.withTextBefore,
                onPressed: (i) => print(i),
                onLongPressed: (i) => print(i),
              );
            },
          ),
          const SizedBox(
            height: 30,
          ),
          const Text(
            "Languages",
            style: TextStyle(
              color: Color.fromARGB(255, 9, 9, 9),
              letterSpacing: 1,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          Tags(
            key: _languagesTagKey,
            itemCount: languagesTag.length,
            columns: 6,
            itemBuilder: (index) {
              final Item currentItem = languagesTag[index];

              return ItemTags(
                index: index,
                title: currentItem.title,
                customData: currentItem.customData,
                textStyle: TextStyle(fontSize: 15),
                combine: ItemTagsCombine.withTextBefore,
                onPressed: (i) => print(i),
                onLongPressed: (i) => print(i),
              );
            },
          ),
        ]),
      ),
    );
  }
}
