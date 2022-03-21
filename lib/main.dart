import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:qr_reader/providers/scan_list_provider.dart';
import 'package:qr_reader/providers/ui_provider.dart';
import 'pages/pages.dart';

void main() => runApp(MyApp());

// ignore: use_key_in_widget_constructors
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: <ChangeNotifierProvider<dynamic>>[
        ChangeNotifierProvider<UiProvider>(
          create: (_) => UiProvider(),
        ),
        ChangeNotifierProvider<ScanListProvider>(
          create: (_) => ScanListProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'QR Reader App',
        initialRoute: 'home',
        routes: <String, Widget Function(BuildContext)>{
          'home': (_) => HomePage(),
          'map': (_) => MapPage(),
        },
        theme: ThemeData(primarySwatch: Colors.deepPurple),
      ),
    );
  }
}

/**
 * THEMEDATA: EL COLOR PRIMARIO NO CAMBIA DEL TEMA AL INTENTAR AGREGAR UN COLOR PRIMARIO. VER:
 * https://stackoverflow.com/questions/69169306/flutter-themedata-primary-color-not-changing-from-theme-when-trying-to-add-a-pri
 * 
 * PARA OBTENER EL FICHERO ScansDB.db (HAY QUE HACERLO EN MODO ROOT -adb root-):
 * /home/enrique/Android/Sdk/platform-tools/adb pull /data/user/0/com.example.qr_reader/app_flutter/ScansDB.db /home/enrique/
 * 
 * Hide your api keys from your android manifest file with Flutter using local.properties. VER:
 * https://dev.to/no2s14/hide-your-api-keys-from-your-android-manifest-file-with-flutter-using-local-properties-3f4e
 * 
 * ¿Por qué no se proporciona el valor de ${applicationName} después de migrar mi aplicación Flutter a Android incrustado v2?. VER:
 * https://stackoverflow.com/questions/69896828/why-is-the-value-for-applicationname-not-supplied-after-migrating-my-flutter
 */
