import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'config/theme.dart';
import 'providers/auth_provider.dart';
import 'providers/dashboard_provider.dart';
import 'providers/drivers_provider.dart';
import 'providers/trips_provider.dart';
import 'providers/vehicles_provider.dart';
import 'screens/login_screen.dart';
import 'screens/admin/admin_home_screen.dart';
import 'screens/driver/driver_home_screen.dart';
import 'screens/splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Türkçe tarih formatı için dil desteğini başlat
  initializeDateFormatting('tr_TR', null);
  
  // Durum çubuğu görünümünü ayarla
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
  ));
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => DashboardProvider()),
        ChangeNotifierProvider(create: (_) => DriversProvider()),
        ChangeNotifierProvider(create: (_) => TripsProvider()),
        ChangeNotifierProvider(create: (_) => VehiclesProvider()),
      ],
      child: MaterialApp(
        title: 'Lojistik Uygulaması',
        theme: AppTheme.lightTheme,
        home: const AuthWrapper(), // Oturum durumuna göre yönlendirecek
        debugShowCheckedModeBanner: false,
        // Türkçe dil desteği
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('tr', 'TR'), // Türkçe
          Locale('en', 'US'), // İngilizce (yedek)
        ],
        locale: const Locale('tr', 'TR'), // Varsayılan dil Türkçe
      ),
    );
  }
}

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  @override
  void initState() {
    super.initState();
    // Uygulama başladığında oturum durumunu kontrol et
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AuthProvider>(context, listen: false).checkAuthStatus();
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    // Oturum durumu kontrol ediliyor
    if (authProvider.isLoading) {
      return const SplashScreen();
    }

    // Giriş yapılmışsa role göre sayfa göster
    if (authProvider.isLoggedIn) {
      if (authProvider.isAdmin) {
        return const AdminHomeScreen();
      } else if (authProvider.isDriver) {
        return const DriverHomeScreen();
      }
    }

    // Giriş yapılmamışsa login ekranını göster
    return const LoginScreen();
  }
}