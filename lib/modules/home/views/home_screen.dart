import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/res/app_url.dart';
import '../../../core/utils/routes/routes_name.dart';
import '../../../core/utils/ui_helper.dart';
import '../../../data/models/category_model.dart';
import '../../../data/models/service_provider_model.dart';
import '../../../data/services/api_service.dart';
import '../../../view_model/message_view_model.dart';
import '../../Bottom_navigation/views/bottom_navigation.dart';
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
  ];

  List<CategoryModel> filteredCategories = [];

  @override
  void initState() {
    super.initState();
    filteredCategories = allCategories;
    _searchController.addListener(_onSearchChanged);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<MessagesViewModel>(context, listen: false).fetchNotifications();
    });
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

  void _onCategoryTap(String categoryName) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );
    
    try {
      final response = await ApiService().getRequest(AppUrl.allProviders, requireAuth: true);
      if (mounted) Navigator.pop(context); // remove dialog
      
      if (response['success'] == true) {
        final List<dynamic> providersJson = response['data']['providers'] ?? [];
        final List<ServiceProvider> allProviders = providersJson
            .map((json) => ServiceProvider.fromJson(json))
            .toList();
            
        final filteredProviders = allProviders
            .where((p) => p.profession == categoryName)
            .toList();

        if (mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ServiceProvidersScreen(
                categoryName: categoryName,
                providers: filteredProviders,
              ),
            ),
          );
        }
      } else {
        if (mounted) UIHelper.showFlushbarError(context, response['message'] ?? "Failed to load providers");
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context);
        UIHelper.showFlushbarError(context, e.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textBody = isDark ? Colors.white : Colors.black;
    final subColor = isDark ? Colors.white60 : Colors.black54;
    final tileColor = isDark ? const Color(0xFF2A2A2A) : Colors.grey.shade200;
    final searchFill = isDark ? const Color(0xFF1E1E1E) : Colors.grey.shade100;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("My Location",
                            style: TextStyle(color: subColor)),
                        Text(
                          location,
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold, color: textBody),
                        ),
                      ],
                    ),
                  ),
                  Consumer<MessagesViewModel>(
                    builder: (context, vm, child) {
                      final unread = vm.unreadNotificationCount;
                      return Stack(
                        clipBehavior: Clip.none,
                        children: [
                          IconButton(
                            onPressed: () {
                              Navigator.pushNamed(context, RoutesName.notifications);
                            },
                            icon: Icon(
                              unread > 0 ? Icons.notifications_active : Icons.notifications_outlined,
                              color: Colors.blue,
                              size: 28,
                            ),
                          ),
                          if (unread > 0)
                            Positioned(
                              right: 6,
                              top: 6,
                              child: Container(
                                padding: const EdgeInsets.all(2),
                                constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
                                decoration: const BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Text(
                                    unread > 99 ? '99+' : '$unread',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _searchController,
                style: TextStyle(color: textBody),
                decoration: InputDecoration(
                  hintText: "Search service (e.g., Plumber)",
                  hintStyle: TextStyle(color: subColor),
                  prefixIcon: Icon(Icons.search, color: subColor),
                  suffixIcon: Container(
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.arrow_forward, color: Colors.white),
                  ),
                  filled: true,
                  fillColor: searchFill,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              if (_searchController.text.isNotEmpty && filteredCategories.isNotEmpty) ...[
                const SizedBox(height: 20),
                Text(
                  "Search Results",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textBody),
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
                              color: tileColor,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Image.asset(category.images),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            category.name,
                            style: TextStyle(fontSize: 10, color: textBody),
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
                          ],
                        ),
                      ),
                      Image.asset("assets/images/worker.png",
                          height: 150, width: 150),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                Text(
                  "Popular Services",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textBody),
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
                              color: tileColor,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Image.asset(category.images),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            category.name,
                            style: TextStyle(fontSize: 10, color: textBody),
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
