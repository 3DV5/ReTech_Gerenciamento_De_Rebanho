import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/home_screen.dart';
import 'providers/farm_provider.dart';
import 'providers/cattle_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  final farmProvider = FarmProvider();
  final cattleProvider = CattleProvider();
  
  // Carrega os dados iniciais
  await farmProvider.loadFarms();
  await cattleProvider.loadCattle();
  
  runApp(MyApp(
    farmProvider: farmProvider,
    cattleProvider: cattleProvider,
  ));
}

class MyApp extends StatelessWidget {
  final FarmProvider farmProvider;
  final CattleProvider cattleProvider;

  const MyApp({
    super.key,
    required this.farmProvider,
    required this.cattleProvider,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: farmProvider),
        ChangeNotifierProvider.value(value: cattleProvider),
      ],
      child: MaterialApp(
        title: 'Gerenciamento de Gado',
        theme: ThemeData(
          primarySwatch: Colors.red,
          colorScheme: ColorScheme.fromSwatch(
            primarySwatch: Colors.green,
            accentColor: Colors.amber,
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            titleTextStyle: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            iconTheme: IconThemeData(color: Colors.white),
          ),
        ),
        home: const HomeScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}