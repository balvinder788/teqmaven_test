import 'package:flutter/material.dart';

class Uiutils {
  static var searchDecoration = BoxDecoration(
    borderRadius: BorderRadius.circular(100),
    color: Colors.white,
  );

  static var searchInputDecoration = const InputDecoration(
    border: InputBorder.none,
    errorBorder: InputBorder.none,
    enabledBorder: InputBorder.none,
    disabledBorder: InputBorder.none,
    focusedBorder: InputBorder.none,
    hintText: "Search place",
    hintStyle: TextStyle(color: Colors.grey),
    prefixIcon: Icon(Icons.search),
    // contentPadding: EdgeInsets.only(
    //   left: 0,
    //   bottom: 0,
    //   right: 0,
    //   top: 0,
    // ),
  );
}
