import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/ui_provider.dart';

// ignore: use_key_in_widget_constructors
class CustomNavigationBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Obtener selectedMenuOption desde el Provider
    final uiProvider = Provider.of<UiProvider>(context);
    // Cambiar para mostrar la página respectiva
    final currentIndex = uiProvider.selectedMenuOption;

    return BottomNavigationBar(
      onTap: (int i) {
        uiProvider.selectedMenuOption = i;
      },
      elevation: 0,
      currentIndex: currentIndex,
      items: const <BottomNavigationBarItem>[
        // Al menos tiene que contener 2 item, si no da error
        BottomNavigationBarItem(
          icon: Icon(Icons.map),
          label: 'Mapas',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.compass_calibration),
          label: 'Direcciones',
        ),
      ],
    );
  }
}
