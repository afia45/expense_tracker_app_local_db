import 'package:expense_tracker_app_2/UI/splashscreen.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import '/UI/Settings/setting.dart';
import '/UI/addBugdet/addbudgetmodel.dart';
import '/UI/budget/budget_model.dart';
import '/widget/bottomnavigationbar.dart';
import '/UI/home/homepage.dart';
import 'models/model.dart';
import 'providers/provider.dart';
import '/UI/budget/budget_provider.dart';
import 'package:provider/provider.dart';
import 'UI/addBugdet/addbudgetprovider.dart';
//!-------------VIEW APP IN DIFFERENT DEVICES------------------------
import 'package:device_preview/device_preview.dart'; // Import DevicePreview
import 'package:flutter/foundation.dart'; // Required for kReleaseMode
//!------------------------------------------------------

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  
  // Register Hive adapters
  if (!Hive.isAdapterRegistered(BudgetModelAdapter().typeId)) {
    Hive.registerAdapter(BudgetModelAdapter());
  }
  if (!Hive.isAdapterRegistered(AddBudgetModelAdapter().typeId)) {
    Hive.registerAdapter(AddBudgetModelAdapter());
  }
  if (!Hive.isAdapterRegistered(ValueOfTextFormAdapter().typeId)) {
    Hive.registerAdapter(ValueOfTextFormAdapter());
  }

  runApp(MyApp());
  //!------------DEVICE PREVIEW--------------------------------
  // runApp(DevicePreview(
  //   enabled: !kReleaseMode, // Disable Device Preview in Release mode
  //   builder: (context) => const MyApp(),
  // ));
  //!--------------------------------------------
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AddListProvider()),
        ChangeNotifierProvider(create: (_) => BudgetProvider()),
        ChangeNotifierProvider(create: (_) => AddBudgetProvider()),
      ],
      child: Consumer<AddListProvider>(
        builder: (context, provider, _) {
          return MaterialApp(
            //!----------------DEVICE PREVIEW----------------------------
            // useInheritedMediaQuery: true, // Required for Device Preview
            // builder: DevicePreview.appBuilder, // Use DevicePreview's builder
            // locale: DevicePreview.locale(context), // Use locale from Device Preview
            //!--------------------------------------------

            theme: ThemeData(
              fontFamily: "DMSans",
              primaryColor: Colors.white,
              appBarTheme: AppBarTheme(backgroundColor: Colors.white,),
              scaffoldBackgroundColor: Colors.white,
              textTheme: TextTheme(bodyMedium: TextStyle(color: Colors.black)),
              // Add any additional light theme customizations here
            ),
            darkTheme: ThemeData.dark().copyWith(
              primaryColor: Colors.black,
              appBarTheme: AppBarTheme(backgroundColor: Colors.grey[600],),
              scaffoldBackgroundColor: Colors.grey[800],
              textTheme: const TextTheme(bodyMedium: TextStyle(color: Colors.white),),
              // Add any additional dark theme customizations here
            ),
            themeMode: provider.isDarkTheme ? ThemeMode.dark : ThemeMode.light,
            debugShowCheckedModeBanner: false,
            initialRoute: '/splash',
            routes: {
              '/splash': (context) => const SplashScreen(),
              '/home': (context) => const BottomNavigationBarPage(),
            },
          );
        },
      ),
    );
  }
}
