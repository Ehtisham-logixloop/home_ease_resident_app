import 'package:flutter/material.dart';

import '../../../data/models/category_model.dart';
import '../../../data/models/service_provider_model.dart';
import '../../main/views/bottom_navigation.dart';
import '../views/service_providers_screen.dart';


class HomeScreen extends StatefulWidget {
   const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final String location = "Gujranwala Garden Town";
  final TextEditingController _searchController = TextEditingController();

  final List<CategoryModel> categories = [
    CategoryModel(name: "Plumber", images: "assets/images/plumber.png"),
    CategoryModel(name: "Carpenter", images: "assets/images/carpenter.png"),
    CategoryModel(name: "Electrician", images: "assets/images/electrician.png"),
    CategoryModel(name: "Cleaner", images: "assets/images/cleaner.png"),
  ];

  final List<CategoryModel> allCategories = [
    CategoryModel(name: "Plumber", images: "assets/images/plumber.png"),
    CategoryModel(name: "Carpenter", images: "assets/images/carpenter.png"),
    CategoryModel(name: "Electrician", images: "assets/images/electrician.png"),
    CategoryModel(name: "Cleaner", images: "assets/images/cleaner.png"),
    CategoryModel(name: "AC Repair", images: "assets/images/ac.png"),
    CategoryModel(name: "Men’s saloon", images: "assets/images/salon.png"),
    CategoryModel(name: "Painter", images: "assets/images/painter.png"),
    CategoryModel(name: "Beauty", images: "assets/images/beauty.png"),
    CategoryModel(name: "Automobile", images: "assets/images/automotive.png"),
    CategoryModel(name: "Shifting", images: "assets/images/shifting.png"),
    CategoryModel(name: "Home Appliance", images: "assets/images/appliances.png"),
    CategoryModel(name: "Solar Install", images: "assets/images/home.png"),
  ];

  List<CategoryModel> filteredCategories = [];

  @override
  void initState() {
    super.initState();
    filteredCategories = allCategories;
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      if (_searchController.text.isEmpty) {
        filteredCategories = allCategories;
      } else {
        filteredCategories = allCategories
            .where((category) => category.name.toLowerCase()
            .contains(_searchController.text.toLowerCase()))
            .toList();
      }
    });
  }

  void _onCategoryTap(String categoryName) {
    final List<ServiceProvider> providers = [
      ServiceProvider(
        id: "1",
        name: "Ali Raza",
        profession: categoryName,
        rating: 4.8,
        pricePerHour: 500,
        image: "assets/images/user.png",
        description: "Expert in fixing pipes and water leaks. 8 years of experience.",
        yearsOfExperience: 8,
        servicesOffered: ["Pipe Repair", "Water Leak Fix", "Drain Cleaning"],
      ),
      ServiceProvider(
        id: "2",
        name: "Ahmed Khan",
        profession: categoryName,
        rating: 4.5,
        pricePerHour: 450,
        image: "assets/images/user.png",
        description: "Reliable and professional service.",
        yearsOfExperience: 5,
        servicesOffered: ["Basic Repairs", "Installation"],
      ),
      ServiceProvider(
        id: "3",
        name: "Hassan Ali",
        profession: categoryName,
        rating: 4.9,
        pricePerHour: 600,
        image: "assets/images/user.png",
        description: "Top-rated professional with excellent reviews.",
        yearsOfExperience: 10,
        servicesOffered: ["Emergency Repairs", "Full Service"],
      ),
    ];

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ServiceProvidersScreen(
          categoryName: categoryName,
          providers: providers,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              Row(
                children: [
                  Image.asset("assets/images/stash.png", width: 30, height: 30),
                  const SizedBox(width: 6),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("My Location",
                          style: TextStyle(color: Colors.black54)),
                      Text(
                        location,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  )
                ],
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: "Search service (e.g., Plumber)",
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: Container(
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.arrow_forward, color: Colors.white),
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              if (_searchController.text.isNotEmpty && filteredCategories.isNotEmpty) ...[
                const SizedBox(height: 20),
                const Text(
                  "Search Results",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: filteredCategories.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 0.8,
                  ),
                  itemBuilder: (context, index) {
                    final category = filteredCategories[index];
                    return GestureDetector(
                      onTap: () => _onCategoryTap(category.name),
                      child: Column(
                        children: [
                          Container(
                            height: 60,
                            width: 60,
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Image.asset(category.images),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            category.name,
                            style: const TextStyle(fontSize: 10),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
              if (_searchController.text.isEmpty) ...[
                const SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  height: 200,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "30% Off\nSpecial Deals",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              "Get discount for every order",
                              style: TextStyle(color: Colors.white70),
                            ),
                            SizedBox(height: 12),
                            ElevatedButton(
                              onPressed: null,
                              style: ButtonStyle(
                                backgroundColor:
                                MaterialStatePropertyAll(Colors.white),
                              ),
                              child: Text(
                                "Order now",
                                style:
                                TextStyle(color: Colors.blue, fontSize: 12),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Image.asset("assets/images/worker.png",
                          height: 150, width: 150),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                const Text(
                  "Popular Services",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: categories.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 0.8,
                  ),
                  itemBuilder: (context, index) {
                    final category = categories[index];
                    return GestureDetector(
                      onTap: () => _onCategoryTap(category.name),
                      child: Column(
                        children: [
                          Container(
                            height: 60,
                            width: 60,
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Image.asset(category.images),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            category.name,
                            style: const TextStyle(fontSize: 10),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ],
          ),
        ),
      ),
      bottomNavigationBar: const CustomBottomBar(currentIndex: 0),
    );
  }
}

