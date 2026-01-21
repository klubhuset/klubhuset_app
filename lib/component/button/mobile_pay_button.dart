import 'package:flutter/cupertino.dart';
import 'package:kopa/component/button/button.dart';
import 'package:kopa/helpers/url_opener.dart';

class MobilePayButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Button(
        buttonText: 'Gå til MobilePay Box',
        onPressed: () {
          UrlOpener.openMobilePay();
        },
        outlined: true);
  }
}
