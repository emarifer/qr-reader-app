import 'package:flutter/material.dart';

import 'package:qr_reader/providers/db_provider.dart';

class ScanListProvider extends ChangeNotifier {
  List<ScanModel> scans = [];
  String selectedType = 'http';

  Future<ScanModel> newScan(String value) async {
    final ScanModel nwSc = ScanModel(value: value);

    final int iD = await DBProvider.db.newScan(nwSc);

    // Asignar el ID de la base de datos a la nueve instancia del modelo ScanModel
    nwSc.id = iD;

    // Insertar la nueva instancia el la lista del Provider;
    // Solo se inserta si el tipo es 'http'
    if (selectedType == nwSc.type) {
      scans.add(nwSc);

      // Noftica a los Widgets subscritos cuando cambia la list scans
      notifyListeners();
    }

    return nwSc;
  }

  void loadScans() async {
    final List<ScanModel> scs = await DBProvider.db.getAllScans();
    // «Esparcimos» con el spread operator el listado scs en el atributo scans
    scans = [...scs];

    notifyListeners();
  }

  void loadScansByType(String type) async {
    final List<ScanModel> scs = await DBProvider.db.getScansByType(type);
    // Asignamos el tipo recibido a selectedType para seleccionar que se muestra el la UI
    selectedType = type;
    // «Esparcimos» con el spread operator el listado scs en el atributo scans
    scans = [...scs];

    notifyListeners();
  }

  void deleteAll() async {
    // Borramos todos los registros de la DB
    await DBProvider.db.deleteAllScans();
    // Limpiamos la lista que se muestra en la UI
    scans = [];
    // Y notificamos a los widgets
    notifyListeners();
  }

  Future<int> removeScanById(int iD) async {
    return await DBProvider.db.deleteScan(iD);
    // No hace falta llamar al notifyListeners() porque loadScansByType ya lo tiene
    // loadScansByType(selectedType);
    // Ya lo elimina visualmente del Dismissible
  }
}
