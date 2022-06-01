import 'package:belajarfirebase/themes/color_theme.dart';
import 'package:flutter/material.dart';

class BottomMenu extends StatelessWidget {
  BottomMenu({Key? key, required this.menuActive}) : super(key: key);

  String menuActive = "chat";

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        decoration: BoxDecoration(
          color: ColorsSetting.shadowColor,
          borderRadius: const BorderRadius.all(
            Radius.circular(100),
          ),
          boxShadow: [
            BoxShadow(
              color: ColorsSetting.shadowColor,
              spreadRadius: 5,
              blurRadius: 25,
            )
          ],
        ),
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
        margin: const EdgeInsets.symmetric(vertical: 30, horizontal: 75),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              decoration: BoxDecoration(
                  color: menuActive == "chat"
                      ? ColorsSetting.secondaryColor
                      : ColorsSetting.shadowColor,
                  borderRadius: const BorderRadius.all(Radius.circular(50))),
              child: IconButton(
                iconSize: 30,
                color: menuActive == "chat"
                    ? ColorsSetting.shadowColor
                    : ColorsSetting.secondaryColor,
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                      context, "/home", (route) => false);
                },
                icon: const Icon(Icons.person),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                  color: menuActive == "addstory"
                      ? ColorsSetting.secondaryColor
                      : ColorsSetting.shadowColor,
                  borderRadius: const BorderRadius.all(Radius.circular(50))),
              child: IconButton(
                iconSize: 30,
                color: menuActive == "addstory"
                    ? ColorsSetting.shadowColor
                    : ColorsSetting.secondaryColor,
                onPressed: () {
                  Navigator.pushNamed(context, "/addstory");
                },
                icon: const Icon(Icons.add_a_photo),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                  color: menuActive == "groupchat"
                      ? ColorsSetting.secondaryColor
                      : ColorsSetting.shadowColor,
                  borderRadius: const BorderRadius.all(Radius.circular(50))),
              child: IconButton(
                iconSize: 30,
                color: menuActive == "groupchat"
                    ? ColorsSetting.shadowColor
                    : ColorsSetting.secondaryColor,
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                      context, "/groupchat", (route) => false);
                },
                icon: const Icon(Icons.group),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
