import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:me_reach/app/utils/app_routes.dart';

class AppWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: Modular.navigatorKey,
      title: 'MeReach',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: AppRoutes.homeModule,
      onGenerateRoute: Modular.generateRoute,
    );
  }
}
