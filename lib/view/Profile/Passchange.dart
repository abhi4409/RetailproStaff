import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../viewmodel/changepassword_viewmodel.dart';

class Changepa extends StatefulWidget {
  Changepa({
    super.key,
  });

  @override
  State<Changepa> createState() => _ChangepaState();
}

class _ChangepaState extends State<Changepa> {
  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<ChangePasswordViewmodel>(
      context,
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        title: Text(
          "Change Password",
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
        child: Column(
          children: [
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 35,
                      backgroundColor: Colors.blue.shade50,
                      child: Icon(
                        Icons.lock_reset,
                        size: 35,
                        color: Colors.blue,
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      "Update Password",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      "Update your account password securely",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            TextField(
              controller: provider.currentPassword,
              obscureText: true,
              decoration: InputDecoration(
                labelText: "Current Password",
                prefixIcon: Icon(
                  Icons.lock_outline,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            TextField(
              controller: provider.newPassword,
              obscureText: true,
              decoration: InputDecoration(
                labelText: "New Password",
                prefixIcon: Icon(
                  Icons.lock_outline,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            TextField(
              controller: provider.reenterPassword,
              obscureText: true,
              textInputAction: TextInputAction.done,
              onSubmitted: (value) async {
                await provider.changePassword(
                  context,
                );
              },
              decoration: InputDecoration(
                labelText: "Confirm New Password",
                prefixIcon: Icon(
                  Icons.lock_outline,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            SizedBox(
              height: 25,
            ),
            ElevatedButton(
              onPressed: provider.loading
                  ? null
                  : () async {
                await provider.changePassword(
                  context,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                minimumSize: Size(
                  double.infinity,
                  50,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: provider.loading
                  ? SizedBox(
                height: 22,
                width: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
                  : Text(
                "Change Password",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}