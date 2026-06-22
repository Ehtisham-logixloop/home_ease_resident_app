import 'package:flutter/material.dart';

import '../../main/views/bottom_navigation.dart';



class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          "My Profile",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 10),
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                const CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage("assets/images/profile_image.png"),
                ),
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.camera_alt,
                      size: 18, color: Colors.white),
                )
              ],
            ),
            const SizedBox(height: 40),
            ListTile(
              leading: Icon(Icons.perm_identity_outlined),
              title: Text("Edit Profile",style: TextStyle(fontSize: 12),),
              trailing: Icon(Icons.arrow_forward_ios, size: 14),
            ),
            const Divider(),
            const ListTile(
              leading: Icon(Icons.local_mall_outlined),
              title: Text("Change Password",style: TextStyle(fontSize: 12),),
              trailing: Icon(Icons.arrow_forward_ios, size: 14),
            ),
            const Divider(),
            const ListTile(
              leading: Icon(Icons.calendar_month),
              title: Text("My Bookings",style: TextStyle(fontSize: 12),),
              trailing: Icon(Icons.arrow_forward_ios, size: 14),
            ),
            const Divider(),
            const ListTile(
              leading: Icon(Icons.location_on_outlined),
              title: Text("My Address",style: TextStyle(fontSize: 12),),
              trailing: Icon(Icons.arrow_forward_ios, size: 14),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.visibility_outlined),
              title: const Text("Dark Mode",style: TextStyle(fontSize: 12),),
              trailing: Transform.scale(
                scale: 0.6,
                child: Switch(
                  value: false,
                  onChanged: (val) {},
                ),
              ),
            ),
            const Divider(),
            const ListTile(
              leading: Icon(Icons.shield_outlined),
              title: Text("My Privacy",style: TextStyle(fontSize: 12),),
              trailing: Icon(Icons.arrow_forward_ios, size: 14),
            ),const Divider(),
            const ListTile(
              leading: Icon(Icons.logout, color: Colors.blue),
              title: Text("Log out", style: TextStyle(color: Colors.blue,fontSize: 12)),
            ),
          ],
        ),
      ),
      ),
        bottomNavigationBar: const CustomBottomBar(currentIndex: 3),
    );
  }
}

