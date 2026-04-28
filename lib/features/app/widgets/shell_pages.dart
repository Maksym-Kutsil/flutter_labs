import 'package:flutter/material.dart';
import 'package:my_project/features/home/home_page.dart';
import 'package:my_project/features/sensor/sensor_page.dart';
import 'package:my_project/pages/pet_bowl_dashboard_page.dart';
import 'package:my_project/pages/pet_bowl_history_page.dart';
import 'package:my_project/pages/pet_bowl_schedule_page.dart';
import 'package:my_project/pages/pet_bowl_settings_page.dart';

/// Static list of pages shown in the authenticated [IndexedStack].
const List<Widget> kShellPages = <Widget>[
  HomePage(),
  PetBowlDashboardPage(),
  SensorPage(),
  PetBowlSchedulePage(),
  PetBowlHistoryPage(),
  PetBowlSettingsPage(),
];
