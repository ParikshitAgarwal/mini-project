import 'package:flutter/material.dart';

class UserDetailScreen extends StatelessWidget {
  String? plateNum;
  UserDetailScreen({Key? key, required this.plateNum}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // print(plateNum);
    plateNum = plateNum!.replaceAll("\n", "");
    return Scaffold(
      appBar: AppBar(
        title: Text("User Detail"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 50,
            ),
            Center(
              child: CircleAvatar(
                radius: 100,
                backgroundImage: AssetImage(
                  "assets/avatar.png",
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              "FullName: John Doe",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text("Reg_no: $plateNum",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            Text("Chasis_no: MBLKC12EFBGJ08420",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            Text("Mobile: 91061XXXXX",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            Text("Email: johndoe@gmail.com",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold))
          ],
        ),
      ),
    );
  }
}
