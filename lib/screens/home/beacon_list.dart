import 'package:flutter/material.dart';
import 'package:rivi_mvp/screens/home/beacon_tile.dart';
import 'package:provider/provider.dart';
import 'package:rivi_mvp/models/models.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BeaconList extends StatefulWidget {
  @override
  _BeaconListState createState() => _BeaconListState();
}

class _BeaconListState extends State<BeaconList> {
  @override
  Widget build(BuildContext context) {
    final beacons = Provider.of<List<Beacon>>(context) ?? [];

    return ListView.builder(
      itemCount: beacons.length,
      itemBuilder: (context, index) {
        return BeaconTile(beacon: beacons[index]);
      },
    );;
  }
}
