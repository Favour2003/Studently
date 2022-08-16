import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tags/flutter_tags.dart';
import 'package:studently/model/user.dart';
import 'package:studently/screens/tutorScreens/chat_details.dart';
import 'package:studently/services/storage_service.dart';
import 'package:studently/shared/loading.dart';

class SearchResultTutor extends StatefulWidget {
  const SearchResultTutor(
      {Key? key, required this.searchdata, required this.tutordata})
      : super(key: key);
  final List<QueryDocumentSnapshot<Object?>> searchdata;
  final List<Tutors?> tutordata;

  @override
  State<SearchResultTutor> createState() => _SearchResultTutorState();
}

class _SearchResultTutorState extends State<SearchResultTutor> {
  //widget.searchdata[0]["name"].toString()
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
    return loading
        ? const Loading()
        : Scaffold(
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
                setState(() {
                  loading = true;
                });
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ChatDetails(
                            friendUserId:
                                widget.searchdata[0]["uid"].toString(),
                            friendFullName:
                                widget.searchdata[0]["username"].toString(),
                            friendProfilePhoto: widget.searchdata[0]
                                    ["photofilepath"]
                                .toString(),
                            tutordata: widget.tutordata,
                          )),
                );
                setState(() {
                  loading = false;
                });
              },
              child: const Icon(Icons.message),
              backgroundColor: Colors.green,
            ),
            body: Padding(
              padding: const EdgeInsets.fromLTRB(30, 10, 30, 0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
