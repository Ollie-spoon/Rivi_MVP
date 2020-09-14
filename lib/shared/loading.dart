import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:rivi_mvp/shared/colors.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: secondaryColor,
      child: Center(
        child: SpinKitWave(
          color: primaryColor,
          size: 50,
        ),
      ),
    );
  }
}
