import 'package:flutter/material.dart';
import 'package:rivi_mvp/models/user.dart';
import 'package:google_fonts/google_fonts.dart';

class BeaconTile extends StatelessWidget {

  final Beacon beacon;

  BeaconTile({this.beacon});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 8),
      child: Card(
        margin: EdgeInsets.fromLTRB(20, 6, 20, 0),
        child: ListTile(
          leading: Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Icon(
              Icons.bluetooth,
              size: 30,
              color: Colors.green,
            ),
          ),
          title: Text("Connection made"),
          subtitle: Text(
            "Beacon ID: ${beacon.bid}",
            //style: GoogleFonts.ubuntu(),
          ),
        ),
      ),
    );
  }
}
