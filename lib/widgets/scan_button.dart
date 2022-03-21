import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/scan_list_provider.dart';
import '../utils/utils.dart';

// ignore: use_key_in_widget_constructors
class ScanButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      elevation: 0,
      child: const Icon(Icons.filter_center_focus),
      onPressed: () async {
        String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
            '#3D8BEF', 'Cancelar', false, ScanMode.QR);
        // const String barcodeScanRes =
        //     'http://www.grupocollados.com/observatorio/sites/default/files/weather/ipcam/ipcam.jpg';
        // const String barcodeScanRes = 'geo:38.109957,-2.557166';

        if (barcodeScanRes == '-1') return;

        // listen en false para que no se redibuje cuando pase por este punto
        // porque estamos dentro de un metodo
        final ScanListProvider scanListProvider =
            Provider.of<ScanListProvider>(context, listen: false);
        final nwSc = await scanListProvider.newScan(barcodeScanRes);

        launchURL(context, nwSc);
      },
    );
  }
}
