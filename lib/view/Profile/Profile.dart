import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../viewmodel/profile_viewmodel.dart';
import '../Login/Loginpage.dart';
import 'Aboutus.dart';
import 'Myprofile.dart';
import 'Passchange.dart';
import 'Privacy_policy.dart';

class Profi extends StatefulWidget {
  Profi({
    super.key,
  });

  @override
  State<Profi> createState() => _ProfiState();
}

class _ProfiState extends State<Profi> {
  Future<void> signout(ProfileViewmodel provider) async {
    await provider.signOut();

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Logged out successfully"),
        backgroundColor: Colors.green,
      ),
    );

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => Log(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<ProfileViewmodel>(context);

    if (provider.loading) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: Text(
          "Profile",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          children: [
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Row(
                  children: [
                    Stack(
                      children: [
                        CircleAvatar(
                          radius: 46,
                          backgroundColor: Colors.blue.shade50,
                          backgroundImage: provider.profileImage != null
                              ? MemoryImage(provider.profileImage!)
                              : provider.profileImageUrl.isNotEmpty
                              ? NetworkImage(provider.profileImageUrl)
                          as ImageProvider
                              : null,
                          child: provider.profileImage == null &&
                              provider.profileImageUrl.isEmpty
                              ? Icon(
                            Icons.person,
                            size: 50,
                            color: Colors.blue.shade400,
                          )
                              : null,
                        ),
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: GestureDetector(
                            onTap: provider.imageUploading
                                ? null
                                : () async {
                              await provider.pickProfileImage(context);
                            },
                            child: CircleAvatar(
                              backgroundColor: Colors.blue,
                              radius: 16,
                              child: provider.imageUploading
                                  ? Padding(
                                padding: EdgeInsets.all(3),
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                                  : Icon(
                                Icons.camera_alt,
                                color: Colors.white,
                                size: 16,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            provider.name.text.isEmpty
                                ? "Staff Member"
                                : provider.name.text,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.blue.shade50,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              provider.role.text.isEmpty
                                  ? "Staff"
                                  : provider.role.text.toUpperCase(),
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue.shade700,
                              ),
                            ),
                          ),
                          SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(
                                Icons.email_outlined,
                                size: 16,
                                color: Colors.grey.shade600,
                              ),
                              SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  provider.email.text.isEmpty
                                      ? "No email available"
                                      : provider.email.text,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey.shade700,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(
                                Icons.phone_outlined,
                                size: 16,
                                color: Colors.grey.shade600,
                              ),
                              SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  provider.phone.text.isEmpty
                                      ? "No phone number"
                                      : provider.phone.text,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey.shade700,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 18),
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  ListTile(
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Mypro(),
                        ),
                      );

                      if (!mounted) return;
                      await provider.getProfile();
                    },
                    leading: CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.blue.shade50,
                      child: Icon(
                        Icons.person_outline,
                        color: Colors.blue,
                        size: 22,
                      ),
                    ),
                    title: Text(
                      "My Profile",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    subtitle: Text(
                      "View and edit your profile",
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      size: 14,
                      color: Colors.grey.shade400,
                    ),
                  ),
                  Divider(height: 1),
                  ListTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Changepa(),
                        ),
                      );
                    },
                    leading: CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.indigo.shade50,
                      child: Icon(
                        Icons.lock_outline,
                        color: Colors.indigo,
                        size: 22,
                      ),
                    ),
                    title: Text(
                      "Change Password",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    subtitle: Text(
                      "Update your account password",
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      size: 14,
                      color: Colors.grey.shade400,
                    ),
                  ),
                  Divider(height: 1),
                  ListTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AboutScreen(),
                        ),
                      );
                    },
                    leading: CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.teal.shade50,
                      child: Icon(
                        Icons.info_outline,
                        color: Colors.teal,
                        size: 22,
                      ),
                    ),
                    title: Text(
                      "About App",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    subtitle: Text(
                      "Version 1.0.0",
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      size: 14,
                      color: Colors.grey.shade400,
                    ),
                  ),
                  Divider(height: 1),
                  ListTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Terms(
                            mdFilename: 'terms.md',
                          ),
                        ),
                      );
                    },
                    leading: CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.purple.shade50,
                      child: Icon(
                        Icons.privacy_tip_outlined,
                        color: Colors.purple,
                        size: 22,
                      ),
                    ),
                    title: Text(
                      "Privacy Policy",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    subtitle: Text(
                      "Terms and privacy terms",
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      size: 14,
                      color: Colors.grey.shade400,
                    ),
                  ),
                  Divider(height: 1),
                  ListTile(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (dialogContext) {
                          return AlertDialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            title: Text(
                              "Logout",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            content: Text(
                              "Are you sure you want to logout from your account?",
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(dialogContext);
                                },
                                child: Text(
                                  "Cancel",
                                  style: TextStyle(
                                    color: Colors.grey.shade700,
                                  ),
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () async {
                                  Navigator.pop(dialogContext);
                                  await signout(provider);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: Text("Logout"),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    leading: CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.red.shade50,
                      child: Icon(
                        Icons.logout,
                        color: Colors.red,
                        size: 22,
                      ),
                    ),
                    title: Text(
                      "Logout",
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    subtitle: Text(
                      "Sign out from your account",
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      size: 14,
                      color: Colors.grey.shade400,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}