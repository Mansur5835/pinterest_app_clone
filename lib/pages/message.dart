import 'package:flutter/material.dart';

class MessagePage extends StatefulWidget {
  const MessagePage({Key? key}) : super(key: key);

  @override
  _MessagePageState createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          title: TabBar(
            unselectedLabelColor: Colors.black,
            labelColor: Colors.white,
            indicator: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: Colors.black,
            ),
            tabs: [
              Tab(
                child: Text(
                  "Сообщение",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              Tab(
                child: Text(
                  "Обновления",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
        body: SingleChildScrollView(
          reverse: true,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: 85,
              ),
              Container(
                  alignment: Alignment.center,
                  child: Text(
                    "Делитесь\nидеями c\nдрузьями.",
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 30),
                  )),
              Container(
                padding: EdgeInsets.all(5),
                margin: EdgeInsets.all(15),
                height: 45,
                child: TextField(
                  decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.search,
                        color: Colors.black,
                        size: 30,
                      ),
                      hintText: "Поиск по имени или эл. адресу",
                      border: InputBorder.none),
                ),
                decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(25)),
              ),
              ListTile(
                leading: CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.red,
                  child: Icon(
                    Icons.create_rounded,
                    color: Colors.white,
                  ),
                ),
                title: Text(
                  "Новое",
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 23),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              ListTile(
                leading: CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.red,
                  child: Icon(
                    Icons.people_outlined,
                    color: Colors.white,
                  ),
                ),
                title: Text(
                  "Синхр. контакты",
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 23),
                ),
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
