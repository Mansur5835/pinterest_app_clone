import 'package:flutter/material.dart';

class ShowMiddScreen {
  BuildContext context;
  String uri;
  String name;

  bool isLoading = false;

  double _res = 0;

  double get resProgres => _res;
  bool get isLoadingP => isLoading;

  ShowMiddScreen(
      {required this.context, required this.name, required this.uri});
}

class Mass extends StatelessWidget {
  final icon;
  final title;
  final color;
  final iconColor;
  double iconSize;

  Mass(
      {Key? key,
      required this.iconSize,
      required this.iconColor,
      required this.color,
      required this.icon,
      required this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: color,
          child: Icon(
            icon,
            size: iconSize,
            color: iconColor,
          ),
        ),
        SizedBox(
          height: 15,
        ),
        Text(
          title,
        )
      ],
    );
  }
}
