import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

abstract class BaseStatefulWidget extends StatefulWidget {

  void finish(BuildContext context) {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    } else {
      SystemNavigator.pop();
    }
  }
}
