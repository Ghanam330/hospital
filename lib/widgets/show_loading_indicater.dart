import 'package:flutter/material.dart';
import 'package:hospital/constants/colors.dart';
class ShowLoadingIndicator extends StatelessWidget {
  const ShowLoadingIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return showLoadingIndicator();
  }
  Widget showLoadingIndicator() {
    return const Center(
      child: CircularProgressIndicator(
        color: kPrimaryBlue,
      ),
    );
  }
}
