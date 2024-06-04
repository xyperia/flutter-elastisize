

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:Elastisize/components/sizing_eru.dart';
import 'package:Elastisize/components/sizing_platinum.dart';

void main() {
  runApp(const FlutterElastisizeApp());
}

class mainAppColors {
  static final darkBlue = Color(0xFF1E1E2C);
  static final lightBlue = Color(0xFF2D2D44);
}

class mainAppThemes {
  static final lightTheme = ThemeData(
    primaryColor: mainAppColors.lightBlue,
    brightness: Brightness.light,
  );

  static final darkTheme = ThemeData(
    primaryColor: mainAppColors.darkBlue,
    brightness: Brightness.dark,
  );
}

class FlutterElastisizeApp extends StatelessWidget {
  const FlutterElastisizeApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: mainAppThemes.lightTheme,
      darkTheme: mainAppThemes.darkTheme,
      themeMode: ThemeMode.system,
      scrollBehavior: MyCustomScrollBehavior(),
      debugShowCheckedModeBanner: false,
      routes:
          _components.map((key, value) => MapEntry(key, (context) => value)),
    );
  }
}

Map<String, Widget> _components = {
  '/': const _HomePage(),
  'Platinum Sizing': const SizingPlatinum(),
  'ERU Sizing': const SizingERU()
};

class _HomePage extends StatelessWidget {
  const _HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                  Image.asset(
                 'assets/elasticsearch.png',
                  fit: BoxFit.contain,
                  height: 40,
              ),
              Container(
                  padding: const EdgeInsets.all(8.0), child: Text('elastisize by VTI'))
            ],

          ),
  ),
      body: SizedBox(
        width: double.infinity,
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 250),
            child: GridView.count(
              crossAxisCount: 1, // Number of columns in the grid
              children: List.generate(_components.length-1, (index) {
                final String routeName = _components.keys.elementAt(index+1);
                return InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, routeName);
                  },
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Circular Profile Image
                      CircleAvatar(
                        radius: 80,
                        backgroundColor: mainAppColors.lightBlue,
                        // backgroundImage: NetworkImage('assets/elasticsearch.png'),
                      ),
                      Text(_components.keys.elementAt(index+1), textAlign: TextAlign.center,)

                      // Optional Hover Effect
                      // You could add a semi-transparent overlay on hover
                    ],
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  // Override behavior methods and getters like dragDevices
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      };
}
