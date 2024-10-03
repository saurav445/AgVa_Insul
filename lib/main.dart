import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:insul_app/AuthScreens/SetupProfile.dart';
import 'package:insul_app/AuthScreens/SplashScreen.dart';
import 'package:insul_app/AuthScreens/auth_Provider.dart';
import 'package:insul_app/Middleware/SharedPrefsHelper.dart';
import 'package:insul_app/Screens/AuthModule.dart';
import 'package:insul_app/Screens/BasalWizard.dart';
import 'package:insul_app/Screens/BolusWizard.dart';
import 'package:insul_app/Screens/DeviceSetupScreen.dart';
import 'package:insul_app/Screens/DevicesScreen.dart';
import 'package:insul_app/Screens/GlucoseScreen.dart';
import 'package:insul_app/Screens/HomeScreen.dart';
import 'package:insul_app/Screens/InsulinScreen.dart';
import 'package:insul_app/Screens/NutritionScreen.dart';
import 'package:insul_app/Screens/ProfileScreen.dart';
import 'package:insul_app/Screens/SettingsScreen.dart';
import 'package:insul_app/Screens/SmartbolusScreen.dart';
import 'package:insul_app/Screens/WeightScreen.dart';
import 'package:insul_app/utils/BasalDeliveryNotifier.dart';
import 'package:insul_app/utils/BolusDeliveryNotifier.dart';
import 'package:insul_app/utils/CharacteristicProvider.dart';
import 'package:insul_app/utils/DeviceConnectProvider.dart';
import 'package:insul_app/utils/DeviceProvider.dart';
import 'package:insul_app/utils/GlucoseNotifier.dart';
import 'package:insul_app/utils/NutritionNotifier.dart';
import 'package:insul_app/utils/ReadNotifier.dart';
import 'package:insul_app/utils/Theme.dart';
import 'package:insul_app/utils/ThemeProvider.dart';
import 'package:insul_app/utils/UpdateProfileNotifier.dart';
import 'package:insul_app/utils/WeightNotifier.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPrefsHelper().init();
  FlutterBluePlus.setLogLevel(LogLevel.verbose, color: true);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ReadNotifier()),
        ChangeNotifierProvider(create: (_) => Deviceprovider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => OtpProvider()),
        ChangeNotifierProvider(create: (_) => ResendOtp()),
        ChangeNotifierProvider(create: (_) => Bolusdelivery()),
        ChangeNotifierProvider(create: (_) => BasalDelivery()),
        ChangeNotifierProvider(create: (_) => WeightSetup()),
        ChangeNotifierProvider(create: (_) => GlucoseDelivery()),
        ChangeNotifierProvider(create: (_) => NutritionChartNotifier()),
        ChangeNotifierProvider(create: (_) => ThemeNotifier()),
        ChangeNotifierProvider(create: (_) => ProfileUpdateNotifier()),
        ChangeNotifierProvider(create: (_) => CharacteristicProvider()),
        ChangeNotifierProvider(create: (_) => Deviceconnection()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  final _sharedPref = SharedPrefsHelper();
  @override
  Widget build(
    BuildContext context,
  ) {
    return Consumer<ThemeNotifier>(
      builder: (context, value, child) {
        print('this value ${value.isDarkMode}');
        if (_sharedPref.getBool('darkMode') == true) {
          Provider.of<ThemeNotifier>(context, listen: false)
              .themeMode(_sharedPref.getBool('darkMode')!);
        }

        return MaterialApp(
          theme: lightMode,
          darkTheme: darkMode,
          themeMode: value.isDarkMode && _sharedPref.getBool('darkMode') == true
              ? ThemeMode.dark
              : ThemeMode.light,
          debugShowCheckedModeBanner: false,
          initialRoute: "/SplashScreen",
          routes: {
            "/SplashScreen": (context) => Splashscreen(),
            "/HomeScreen": (context) => HomeScreen(),
            "/DeviceSetupScreen": (context) => DeviceSetupScreen(),
            "/WeightScreen": (context) => WeightScreen(),
            "/InsulinScreen": (context) => InsulinScreen(),
            "/NutritionScreen": (context) => NutritionScreen(),
            "/ProfileScreen": (context) => ProfileScreen(),
            "/SetupProfile": (context) => SetupProfile(),
            "/GlucoseScreen": (context) => GlucoseScreen(),
            "/SettingScreen": (context) => SettingsScreen(),
            "/BolusWizard": (context) => BolusWizard(),
            "/BasalWizard": (context) => BasalWizard(),
            "/SmartBolusScreen": (context) => SmartBolusScreen(),
            "/DevicesScreen": (context) => DevicesScreen(),
            "/Login": (context) => Login(),
          },
        );
      },
    );
  }
}
