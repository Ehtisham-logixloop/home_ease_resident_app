import 'package:flutter/material.dart';
import '../data/models/category_model.dart';


class HomeViewModel extends ChangeNotifier {
  String location = "Gujranwala ";

  List<CategoryModel> categories = [
    CategoryModel(name: "Plumber", images: "assets/images/plumber.png"),
    CategoryModel(name: "Carpenter",images: "assets/images/carpenter.png"),
    CategoryModel(name: "Electrician", images: "assets/images/electrician.png"),
    CategoryModel(name: "AC Repair",images: "assets/images/ac.png"),
    CategoryModel(name: "Men’s saloon",images: "assets/images/salon.png"),
    CategoryModel(name: "Painter", images: "assets/images/painter.png"),
    CategoryModel(name: "Cleaner", images: "assets/images/cleaner.png"),
    CategoryModel(name: "Beauty", images: "assets/images/beauty.png"),
    CategoryModel(name: "Automobile", images: "assets/images/automotive.png"),
    CategoryModel(name: "Shifting", images: "assets/images/shifting.png"),
    CategoryModel(name: "Home Appliance", images: "assets/images/appliances.png"),
    CategoryModel(name: "Solar Install", images: "assets/images/home.png"),
  ];
}

