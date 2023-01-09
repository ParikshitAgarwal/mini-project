import 'dart:convert';
import 'dart:io';

import 'package:anpr_app/detail_screen.dart';
import 'package:anpr_app/user_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import "package:http/http.dart" as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController _textFieldController = TextEditingController();
  File? image;
  var croppedImage;
  String? message = "";

  Future pickImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;
      final imageTemporary = File(image.path);
      setState(() {
        this.image = imageTemporary;
      });
    } on PlatformException catch (e) {
      print("Failed to pick image: $e");
    }
  }

  uploadImage() async {
    String url =
        "https://826b-2405-205-c961-b5e4-f08c-4eeb-6f20-63a.in.ngrok.io/anpr";
    //Http post call
    final request = http.MultipartRequest("POST", Uri.parse(url));
    final headers = {"Content-type": "multipart/form-data"};

    request.files.add(http.MultipartFile(
        'image', image!.readAsBytes().asStream(), image!.lengthSync(),
        filename: image!.path.split("/").last));

    request.headers.addAll(headers);
    final response = await request.send();
    var res = await http.Response.fromStream(response);
    print(res.body);
    final resJson = jsonDecode(res.body);
    message = resJson['message'];
    print(message);

    //Http get call

    final imgResponse = await http.get(Uri.parse(url));

    // print("response--->" + imgResponse.bodyBytes.toString());
    // print(imgResponse.);
    croppedImage = imgResponse.bodyBytes;

    setState(() {});
  }

  Future<void> _displayTextInputDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Input License No.'),
            content: Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    onChanged: (value) {},
                    controller: _textFieldController,
                    decoration: const InputDecoration(hintText: "DLMNXXXX"),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      String plateNum = _textFieldController.text;

                      Navigator.of(context).push(MaterialPageRoute(
                          builder: ((context) => UserDetailScreen(
                                plateNum: plateNum,
                              ))));

                      // _textFieldController.clear();
                      // Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                        fixedSize: const Size(200, 40),
                        // padding:
                        // EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20))),
                    child: const Text(
                      "Submit",
                      style: TextStyle(fontSize: 20),
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("ANPR")),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 20,
              ),
              ElevatedButton.icon(
                icon: const Icon(
                  Icons.camera_alt_outlined,
                  size: 30,
                ),
                onPressed: () async {
                  await pickImage(ImageSource.camera);
                  await uploadImage();

                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => DetailScreen(
                            image: croppedImage,
                            carImg: image,
                            message: message,
                          )));
                },
                label: const Text(
                  "Upload from Camera",
                  style: TextStyle(fontSize: 23),
                ),
                style: ElevatedButton.styleFrom(
                    fixedSize: const Size(300, 60),
                    // padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20))),
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton.icon(
                icon: const Icon(
                  Icons.image_outlined,
                  size: 30,
                ),
                onPressed: () async {
                  try {
                    await pickImage(ImageSource.gallery);
                    await uploadImage();
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => DetailScreen(
                            image: croppedImage,
                            carImg: image,
                            message: message)));
                  } on PlatformException catch (e) {
                    print(e);
                  }
                },
                label: const Text(
                  "Upload from Gallery",
                  style: TextStyle(fontSize: 23),
                ),
                style: ElevatedButton.styleFrom(
                    fixedSize: const Size(300, 60),
                    // padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20))),
              ),
              const SizedBox(
                height: 20,
              ),
              Center(
                child: ElevatedButton.icon(
                  onPressed: () => _displayTextInputDialog(context),
                  icon: const Icon(
                    Icons.input,
                    size: 30,
                  ),
                  label: const Text(
                    "Input License No.",
                    style: TextStyle(fontSize: 25),
                  ),
                  style: ElevatedButton.styleFrom(
                      fixedSize: const Size(300, 60),
                      // padding:
                      // EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20))),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
