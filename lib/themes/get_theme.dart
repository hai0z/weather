import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/setting_provider.dart';

getColorTheme(BuildContext context) {
  String theme = Provider.of<SettingProvider>(context, listen: false).getSelectedTheme;
  if (theme == "Purple") {
    return Colors.purple;
  } else if (theme == "Blue") {
    return Colors.indigo;
  } else if (theme == "Blue Grey") {
    return Colors.blueGrey;
  } else if (theme == "Coffee") {
    return Colors.brown;
  } else {
    return Colors.indigo;
  }
}
