import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/db_provider.dart';
import '../providers/scan_list_provider.dart';
import '../utils/utils.dart';

class ScanTiles extends StatelessWidget {
  const ScanTiles({
    Key? key,
    required this.type,
  }) : super(key: key);

  final String type;

  @override
  Widget build(BuildContext context) {
    // Dentro del build si queremos que se notifique de cambios (listen en true)
    final ScanListProvider scanListProvider =
        Provider.of<ScanListProvider>(context);

    final List<ScanModel> scans = scanListProvider.scans;

    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      itemCount: scans.length,
      itemBuilder: (_, i) => Dismissible(
        key: UniqueKey(),
        background: Container(
          color: Colors.red,
        ),
        onDismissed: (DismissDirection direction) {
          Provider.of<ScanListProvider>(context, listen: false)
              .removeScanById(scans[i].id!);
        },
        child: ListTile(
          leading: Icon(
            type == 'geo' ? Icons.map : Icons.cloud_queue_rounded,
            color: Theme.of(context).primaryColor,
          ),
          title: Text(scans[i].value),
          subtitle: Text('ID: ${scans[i].id}'),
          trailing: const Icon(Icons.keyboard_arrow_right, color: Colors.grey),
          onTap: () => launchURL(context, scans[i]),
        ),
      ),
    );
  }
}

/**
 * ESTO ES LO QUE PASA CUANDO AL PROVIDER NO SE LE PASA EL «listen» EN FALSE:
 * Tried to listen to a value exposed with provider, from outside of the widget tree.

This is likely caused by an event handler (like a button's onPressed) that called
Provider.of without passing `listen: false`.

To fix, write:
Provider.of<ScanListProvider>(context, listen: false);

 */
