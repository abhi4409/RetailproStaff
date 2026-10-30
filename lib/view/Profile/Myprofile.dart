import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodel/profile_viewmodel.dart';
import 'Profile.dart';

class Mypro extends StatefulWidget {
  Mypro({
    super.key,
  });

  @override
  State<Mypro> createState() =>
      _MyproState();
}

class _MyproState
    extends State<Mypro> {
  @override
  Widget build(
      BuildContext context,
      ) {
    var provider =
    Provider.of<ProfileViewmodel>(
      context,
    );

    if (provider.loading) {
      return Scaffold(
        body: Center(
          child:
          CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Your Profile",
        ),
        backgroundColor:
        Colors.blue,
        foregroundColor:
        Colors.white,
      ),
      body:
      SingleChildScrollView(
        padding:
        EdgeInsets.only(
          left: 20,
          right: 20,
          top: 25,
        ),
        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment
              .center,
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius:
                  55,
                  backgroundColor:
                  Colors
                      .cyan
                      .shade100,
                  backgroundImage:
                  provider.profileImage !=
                      null
                      ? MemoryImage(
                    provider
                        .profileImage!,
                  )
                      : provider
                      .profileImageUrl
                      .isNotEmpty
                      ? NetworkImage(
                    provider
                        .profileImageUrl,
                  )
                      : null,
                  child: provider.profileImage ==
                      null &&
                      provider
                          .profileImageUrl
                          .isEmpty
                      ? Icon(
                    Icons.person,
                    size:
                    70,
                    color:
                    Colors.blue,
                  )
                      : null,
                ),
                Positioned(
                  right:
                  0,
                  bottom:
                  0,
                  child:
                  GestureDetector(
                    onTap: provider
                        .imageUploading
                        ? null
                        : () async {
                      await provider
                          .pickProfileImage(
                        context,
                      );
                    },
                    child:
                    CircleAvatar(
                      backgroundColor:
                      Colors.blue,
                      radius:
                      18,
                      child: provider
                          .imageUploading
                          ? Padding(
                        padding:
                        EdgeInsets.all(
                          5,
                        ),
                        child:
                        CircularProgressIndicator(
                          strokeWidth:
                          2,
                          color:
                          Colors.white,
                        ),
                      )
                          : Icon(
                        Icons
                            .camera_alt,
                        color:
                        Colors.white,
                        size:
                        18,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "Tap camera icon to change profile picture",
              style:
              TextStyle(
                fontSize:
                12,
                color:
                Colors.grey,
              ),
            ),
            SizedBox(
              height: 30,
            ),
            TextField(
              controller:
              provider.name,
              readOnly:
              !provider.edit,
              decoration:
              InputDecoration(
                labelText:
                "Name",
                prefixIcon:
                Icon(
                  Icons.person,
                ),
                border:
                OutlineInputBorder(),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            TextField(
              controller:
              provider.phone,
              readOnly:
              !provider.edit,
              keyboardType:
              TextInputType
                  .phone,
              decoration:
              InputDecoration(
                labelText:
                "Mob",
                prefixIcon:
                Icon(
                  Icons.phone,
                ),
                border:
                OutlineInputBorder(),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            TextField(
              controller:
              provider.email,
              readOnly:
              true,
              decoration:
              InputDecoration(
                labelText:
                "Email",
                prefixIcon:
                Icon(
                  Icons.email,
                ),
                border:
                OutlineInputBorder(),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            TextField(
              controller:
              provider.role,
              readOnly:
              true,
              decoration:
              InputDecoration(
                labelText:
                "Role",
                prefixIcon:
                Icon(
                  Icons.verified,
                ),
                border:
                OutlineInputBorder(),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            GestureDetector(
              onTap:
                  () async {
                if (provider.edit ==
                    false) {
                  provider
                      .enableEdit();
                } else {
                  await provider
                      .updateProfile(
                    context,
                  );
                }
              },
              child:
              Container(
                height:
                50,
                width:
                double.infinity,
                decoration:
                BoxDecoration(
                  color:
                  Colors.blue,
                  borderRadius:
                  BorderRadius
                      .circular(
                    10,
                  ),
                ),
                child:
                Center(
                  child:
                  Row(
                    mainAxisAlignment:
                    MainAxisAlignment
                        .center,
                    children: [
                      Icon(
                        provider.edit
                            ? Icons.save
                            : Icons.edit,
                        color:
                        Colors.white,
                      ),
                      SizedBox(
                        width:
                        10,
                      ),
                      Text(
                        provider.edit
                            ? "Save Profile"
                            : "Edit Profile",
                        style:
                        TextStyle(
                          color:
                          Colors.white,
                          fontSize:
                          18,
                          fontWeight:
                          FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
          ],
        ),
      ),
    );
  }
}