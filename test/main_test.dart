// Copyright (c) 2022, Adryan Eka Vandra
// https://github.com/adryanev/flutter-template-architecture-template
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {

  group('App', () {
    testWidgets('renders bootstrap main', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: Text('Hello World!'),
            ),
          ),
        ),
      );
      expect(find.byType(MaterialApp, skipOffstage: false), findsOneWidget);
    });
  });
}
