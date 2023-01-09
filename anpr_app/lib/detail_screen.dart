// import 'dart:io';
import 'dart:io';
import 'dart:typed_data';

import 'package:anpr_app/user_detail_screen.dart';
import 'package:flutter/material.dart';

class DetailScreen extends StatefulWidget {
  Uint8List? image;
  File? carImg;
  String? message;

  DetailScreen({
    Key? key,
    required this.image,
    this.carImg,
    this.message,
  }) : super(key: key);

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  TextEditingController textEditingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    widget.message != "Licence plate not detected!"
        ? textEditingController.text = widget.message!
        : null;
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      appBar: AppBar(title: const Text("Detail Screen")),
      body: Container(
          child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            widget.image != null &&
                    widget.message != "Licence plate not detected!"
                ? Image.memory(
                    Uint8List.fromList(widget.image!),
                  )
                : Image.file(
                    widget.carImg!,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: 300,
                  ),
            const SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Detected No. Plate:",
                  style: TextStyle(fontSize: 20),
                ),
                const SizedBox(
                  width: 10,
                ),
                Container(
                    width: 150,
                    child: TextField(
                      controller: textEditingController,
                      // textAlign: TextAlign.center,
                      decoration:
                          const InputDecoration(hintText: "Please input here"),
                    ))
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            widget.message == "Licence plate not detected!"
                ? const Text(
                    "Licence plate not detected! please enter the licence plate no.")
                : const SizedBox(
                    height: 10,
                  ),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => UserDetailScreen(
                        plateNum: textEditingController.text)));
              },
              child: const Text(
                "Fetch User Details",
                style: TextStyle(fontSize: 20),
              ),
              style: ElevatedButton.styleFrom(
                  fixedSize: const Size(250, 50),
                  // padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20))),
            )
          ],
        ),
      )),
    );
  }
}
