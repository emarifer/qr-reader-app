import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/scan_list_provider.dart';
import '../providers/ui_provider.dart';
import '../widgets/widgets.dart';
import 'pages.dart';

// ignore: use_key_in_widget_constructors
class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text('Historial'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.delete_forever),
            onPressed: () {
              Provider.of<ScanListProvider>(context, listen: false).deleteAll();
            },
          ),
        ],
      ),
      body: _HomePageBody(),
      floatingActionButton: ScanButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: CustomNavigationBar(),
    );
  }
}

class _HomePageBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Obtener selectedMenuOption desde el Provider
    final uiProvider = Provider.of<UiProvider>(context);
    // Cambiar para mostrar la página respectiva
    final currentIndex = uiProvider.selectedMenuOption;

    // PRUEBAS CON LA BASE DE DATOS:
    // DBProvider.db.database;
    // final tempScan = ScanModel(value: 'https://emarifer.com');
    // DBProvider.db.newScan(tempScan);
    // DBProvider.db.getScanById(5).then((scan) => print(scan?.value));
    // DBProvider.db.getAllScans().then((value) => value.forEach((scan) => print(scan.value)));
    // DBProvider.db.getAllScans().then(print);
    // DBProvider.db.getScansByType('http').then(print);
    // DBProvider.db.updateScan(ScanModel(id: 3, type: 'http', value: 'http://micasa.com'));
    // DBProvider.db.deleteAllScans().then(print);
    // DBProvider.db.getScansByType('http').then(print);

    // USAR EL SCANLISTPROVIDER
    // listen en false para que no se redibuje cuando pase por este punto
    // porque estamos dentro de un metodo
    final ScanListProvider scanListProvider =
        Provider.of<ScanListProvider>(context, listen: false);

    switch (currentIndex) {
      case 0:
        scanListProvider.loadScansByType('geo');
        return MapHistoryPage();

      case 1:
        scanListProvider.loadScansByType('http');
        return AddressesPage();

      default:
        return MapPage();
    }
  }
}
