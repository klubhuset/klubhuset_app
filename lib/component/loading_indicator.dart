import 'package:flutter/cupertino.dart';

class LoadingIndicator extends StatelessWidget {
  final double radius;
  final double topSpacing;

  const LoadingIndicator({
    super.key,
    this.radius = 15.0,
    this.topSpacing = 50.0,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: topSpacing),
          CupertinoActivityIndicator(
            radius: radius,
          ),
        ],
      ),
    );
  }
}
