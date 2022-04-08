import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        actions: [
          Icon(
            Icons.share,
            color: Colors.black,
            size: 30,
          ),
          SizedBox(
            width: 15,
          ),
          Icon(
            Icons.more_horiz,
            color: Colors.black,
            size: 35,
          ),
          SizedBox(
            width: 15,
          ),
        ],
      ),
      body: SingleChildScrollView(
        reverse: true,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 15,
            ),
            Container(
              alignment: Alignment.center,
              child: CircleAvatar(
                backgroundColor: Colors.grey.shade300,
                radius: 70,
                child: Text(
                  "I",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 50),
                ),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Container(
              alignment: Alignment.center,
              child: Text(
                "Ilmudin",
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 30),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Container(
              alignment: Alignment.center,
              child: Text(
                "ilmudinUz@gmail.com\n\n0 подписчиков. 0 подписок",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black, fontSize: 18),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(5),
                    margin: EdgeInsets.only(top: 15, left: 15, bottom: 15),
                    height: 45,
                    child: TextField(
                      decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.search,
                            color: Colors.black,
                            size: 30,
                          ),
                          hintText: "Поиск пинов",
                          border: InputBorder.none),
                    ),
                    decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(25)),
                  ),
                ),
                Container(
                    margin: EdgeInsets.all(5),
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.add,
                      size: 40,
                    ))
              ],
            ),
          ],
        ),
      ),
    ));
  }
}
