import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/bootstrap.dart';
import 'package:flutter_clean_architecture/core/di/injector.dart';

void main() {
  configureDependencies(environment: 'dev');
  runApp(const Bootstrap());
}

