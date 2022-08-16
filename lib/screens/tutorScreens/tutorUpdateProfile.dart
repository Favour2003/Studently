import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_tags/flutter_tags.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:studently/model/user.dart';
import 'package:studently/screens/tutorScreens/tutorProfile.dart';
import 'package:studently/screens/wrapper.dart';
import 'package:studently/services/auth.dart';
import 'package:studently/services/database.dart';
import 'package:studently/services/storage_service.dart';
import 'package:studently/shared/loading.dart';
import 'package:studently/shared/registerTextInput.dart';

class TutorUpdateProfile extends StatefulWidget {
  const TutorUpdateProfile({Key? key, required this.tutordata})
      : super(key: key);
  final List<Tutors?> tutordata;

  @override
  State<TutorUpdateProfile> createState() =>
      _TutorUpdateProfileState(tutordata);
}

class _TutorUpdateProfileState extends State<TutorUpdateProfile> {
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<TagsState> _skillsglobalKey = GlobalKey<TagsState>();
  final GlobalKey<TagsState> _languagesglobalKey = GlobalKey<TagsState>();
  bool loading = false;

  final AuthService _auth = AuthService();

  final Storage storage = Storage();

  XFile? _imagefile;
  final ImagePicker _picker = ImagePicker();

  List<Tutors?> tutordata;
  _TutorUpdateProfileState(this.tutordata);

  List languagesTag = [];
  List languages = [];
  List skillsTag = [];
  List skills = [];
  String about = '';
  String name = '';
  String error = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      tutordata[0]!.languages.forEach((language) {
        languagesTag.add(Item(title: language));
        languages.add(language);
      });

      tutordata[0]!.skills.forEach((skill) {
        skillsTag.add(Item(title: skill));
        skills.add(skill);
      });

      about = tutordata[0]!.about;
      name = tutordata[0]!.name;
    });
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? const Loading()
        : Scaffold(
            appBar: AppBar(
              title: const Text(
                "Update Profile",
                style: TextStyle(
                  letterSpacing: 1,
                  fontWeight: FontWeight.bold,
                ),
              ),
              centerTitle: true,
              backgroundColor: Colors.green,
              elevation: 0,
            ),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Form(
                  key: _formKey,
                  child: ListView(
                    children: [
                      imageProfile(),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        initialValue: widget.tutordata[0]!.name,
                        validator: (val) =>
                            val!.isEmpty ? 'Enter your full name.' : null,
                        onChanged: (val) => setState(() {
                          name = val;
                        }),
                        decoration: registerTextInput.copyWith(
                            fillColor:
                                Theme.of(context).primaryColor.withOpacity(0.1),
                            filled: true,
                            prefixIcon: const Icon(
                              Icons.person,
                              color: Colors.green,
                            ),
                            hintText: "Full Name",
                            helperText: "*Name and surname."),
                        onEditingComplete: () =>
                            FocusScope.of(context).nextFocus(),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        initialValue: widget.tutordata[0]!.about,
                        validator: (val) =>
                            val!.isEmpty ? 'Enter your full name.' : null,
                        onChanged: (val) => setState(() {
                          about = val;
                        }),
                        maxLines: 6,
                        decoration: registerTextInput.copyWith(
                            fillColor:
                                Theme.of(context).primaryColor.withOpacity(0.1),
                            filled: true,
                            hintText: "About",
                            helperText: "*Information about yourself."),
                        onEditingComplete: () =>
                            FocusScope.of(context).nextFocus(),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Tags(
                        key: _languagesglobalKey,
                        itemCount: languagesTag.length,
                        columns: 6,
                        textField: TagsTextField(
                            inputDecoration: registerTextInput.copyWith(
                                prefixIcon: const Icon(
                                  Icons.language,
                                  color: Colors.green,
                                ),
                                fillColor: Theme.of(context)
                                    .primaryColor
                                    .withOpacity(0.1),
                                filled: true,
                                labelText: "Add a language",
                                helperText: "*languagesTag that you speak."),
                            width: 10000,
                            textStyle: TextStyle(fontSize: 14),
                            onSubmitted: (String) {
                              setState(() {
                                languagesTag.add(Item(title: String));
                                languages.add(String);
                              });
                            }),
                        itemBuilder: (index) {
                          final Item currentItem = languagesTag[index];

                          return ItemTags(
                            index: index,
                            title: currentItem.title,
                            customData: currentItem.customData,
                            textStyle: TextStyle(fontSize: 14),
                            combine: ItemTagsCombine.withTextBefore,
                            onPressed: (i) => print(i),
                            onLongPressed: (i) => print(i),
                            removeButton: ItemTagsRemoveButton(onRemoved: () {
                              setState(() {
                                languagesTag.removeAt(index);
                                languages.removeAt(index);
                              });
                              return true;
                            }),
                          );
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Tags(
                        key: _skillsglobalKey,
                        itemCount: skillsTag.length,
                        columns: 6,
                        textField: TagsTextField(
                            inputDecoration: registerTextInput.copyWith(
                                prefixIcon: const Icon(
                                  Icons.book,
                                  color: Colors.green,
                                ),
                                fillColor: Theme.of(context)
                                    .primaryColor
                                    .withOpacity(0.1),
                                filled: true,
                                labelText: "Add a skill",
                                helperText: "*educational skills you offer."),
                            width: 10000,
                            textStyle: TextStyle(fontSize: 14),
                            onSubmitted: (String) {
                              setState(() {
                                skillsTag.add(Item(title: String));
                                skills.add(String);
                              });
                            }),
                        itemBuilder: (index) {
                          final Item currentItem = skillsTag[index];

                          return ItemTags(
                            index: index,
                            title: currentItem.title,
                            customData: currentItem.customData,
                            textStyle: TextStyle(fontSize: 14),
                            combine: ItemTagsCombine.withTextBefore,
                            onPressed: (i) => print(i),
                            onLongPressed: (i) => print(i),
                            removeButton: ItemTagsRemoveButton(onRemoved: () {
                              setState(() {
                                skillsTag.removeAt(index);
                                skills.removeAt(index);
                              });
                              return true;
                            }),
                          );
                        },
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      ElevatedButton(
                          style: registerElevatedButtonStyle.copyWith(
                            padding: MaterialStateProperty.all(
                                const EdgeInsets.fromLTRB(100, 20, 100, 20)),
                          ),
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              if (skills.length <= 0 || languages.length <= 0) {
                                setState(() {
                                  error =
                                      "You need to add at least 1 skill and 1 language";
                                  loading = false;
                                });
                              } else {
                                setState(() {
                                  loading = true;
                                });
                                final path = _imagefile?.path;
                                if (path != null) {
                                  await storage.uploadFile(
                                      path, widget.tutordata[0]!.username);
                                }

                                String uname = widget.tutordata[0]!.username;
                                //print("siiiiii" + uname);
                                String imageurl =
                                    await storage.downloadURL(uname);
                                //print(imageurl);

                                await DatabaseService(
                                        uid: widget.tutordata[0]!.uid)
                                    .updateTutorRegistration(name, about,
                                        imageurl, languages, skills)
                                    .then((value) => Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => Wrapper()),
                                        ));
                              }
                            }
                          },
                          child: const Text(
                            'Update',
                            style: TextStyle(fontSize: 15),
                          )),
                      const SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(
                          style: registerElevatedButtonStyle.copyWith(
                            padding: MaterialStateProperty.all(
                                const EdgeInsets.fromLTRB(100, 20, 100, 20)),
                            backgroundColor: MaterialStateProperty.all(
                                Color.fromARGB(255, 169, 170, 169)),
                          ),
                          onPressed: () async {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Wrapper()),
                            );
                          },
                          child: const Text(
                            'Cancel',
                            style: TextStyle(fontSize: 15),
                          )),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            error,
                            style: const TextStyle(
                                color: Colors.red, fontSize: 14),
                          ),
                        ],
                      )
                    ],
                  )),
            ),
          );
  }

  Widget imageProfile() {
    return Center(
      child: Stack(children: [
        CircleAvatar(
          radius: 75.0,
          backgroundImage: _imagefile != null
              ? FileImage(File(_imagefile!.path))
              : NetworkImage(widget.tutordata[0]!.photofilepath)
                  as ImageProvider,
          backgroundColor: Colors.grey,
        ),
        Positioned(
          bottom: 10.0,
          right: 20.0,
          child: InkWell(
            onTap: () {
              showModalBottomSheet(
                  context: context, builder: (Builder) => bottomSheet());
            },
            child: const Icon(
              Icons.add_a_photo,
              color: Colors.teal,
              size: 35.0,
            ),
          ), // Icon
        ), // Positioned// CircleAvatar
      ] //<widget>[]
          ),
    ); // Stack
  }

  Widget bottomSheet() {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 20,
      ),
      child: Column(children: [
        const Text(
          "Choose profile photo",
          style: TextStyle(fontSize: 20.0, color: Colors.black),
        ),
        const SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton.icon(
              onPressed: () {
                takePhoto(ImageSource.camera);
              },
              icon: Icon(Icons.camera),
              label: Text("Camera"),
              style: TextButton.styleFrom(
                primary: Colors.black,
              ),
            ),
            const SizedBox(
              width: 20,
            ),
            TextButton.icon(
              onPressed: () {
                takePhoto(ImageSource.gallery);
              },
              icon: Icon(Icons.image),
              label: Text("Gallery"),
              style: TextButton.styleFrom(
                primary: Colors.black,
              ),
            ),
          ],
        )
      ]),
    );
  }

  void takePhoto(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    setState(() {
      _imagefile = pickedFile;
    });
  }
}
