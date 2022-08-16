import 'package:flutter/material.dart';
import 'package:studently/services/storage_service.dart';

Widget picProfile(String imageName) {
  final Storage storage = Storage();
  return FutureBuilder(
      future: storage.downloadURL(imageName),
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData) {
          return Center(
              child: Stack(children: [
            CircleAvatar(
              backgroundColor: Colors.grey,
              backgroundImage: NetworkImage(snapshot.data!),
              radius: 50,
            ), // Positioned// CircleAvatar
          ] //<widget>[]
                  )); // Image.network // Container
        }
        if (snapshot.connectionState == ConnectionState.waiting ||
            !snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }
        return Container();
      });
}
