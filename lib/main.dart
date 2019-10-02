import 'package:discover_deep_cove/data/database_adapter.dart';
import 'package:discover_deep_cove/data/db.dart';
import 'package:discover_deep_cove/env.dart';
import 'package:discover_deep_cove/util/route_generator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  // Initialize the env singleton
  await DotEnv().load('.env');

  // Preload directories for env
  await Env.load();

  // Force portrait orientation
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(
    DatabaseAdapter(
      adapter: await DB.instance.adapter,
      child: MaterialApp(
        title: Env.appName,
        theme: appTheme(),
        onGenerateRoute: RouteGenerator.generateRoute,
      ),
    ),
  );
}

ThemeData appTheme() {
  return ThemeData(
    //Green
    primaryColor: Color(0xFF8BC34A),
    //Charcoal
    primaryColorDark: Color(0xFF262626),
    //Orange
    accentColor: Color(0xFFFF5026),
    //Dark Gray
    backgroundColor: Color(0xFF363636),

    fontFamily: 'Roboto',
  );
}
