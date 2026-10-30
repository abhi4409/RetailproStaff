import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:retailprostaff/viewmodel/addtobill_viewmodel.dart';
import 'package:retailprostaff/viewmodel/changepassword_viewmodel.dart';
import 'package:retailprostaff/viewmodel/home_viewmodel.dart';
import 'package:retailprostaff/viewmodel/login_viewmodel.dart';
import 'package:retailprostaff/viewmodel/order_viewmodel.dart';
import 'package:retailprostaff/viewmodel/products_viewmodel.dart';
import 'package:retailprostaff/viewmodel/profile_viewmodel.dart';
import 'package:retailprostaff/viewmodel/sales_viewmodel.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'Supabase/Supabaseini.dart';
import 'firebase_options.dart';

import 'View/login/Splash.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  if (SupabaseConfig.url.isNotEmpty &&
      SupabaseConfig.anonKey.isNotEmpty) {
    try {
      await Supabase.initialize(
        url: SupabaseConfig.url,
        anonKey: SupabaseConfig.anonKey,
      );
    } catch (_) {}
  }

  runApp(
    Proclass(),
  );
}

class Proclass extends StatelessWidget {
  const Proclass({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) =>
              LoginViewmodel(),
        ),
        ChangeNotifierProvider(
          create: (context) =>
              HomeViewmodel(),
        ),
        ChangeNotifierProvider(
          create: (context) =>
              ProductsViewmodel(),
        ),
        ChangeNotifierProvider(
          create: (context) =>
              ProfileViewmodel(),
        ),
        ChangeNotifierProvider(
          create: (context) =>
              AddtobillViewmodel(),
        ),
        ChangeNotifierProvider(
          create: (context) =>
              SalesViewmodel(),
        ),
        ChangeNotifierProvider(
          create: (context) =>
              OrderViewmodel(),
        ),
        ChangeNotifierProvider(
          create: (context) =>
              ChangePasswordViewmodel(),
        ),
      ],
      child: MaterialApp(
        home: Spla(),
        debugShowCheckedModeBanner:
        false,
      ),
    );
  }
}