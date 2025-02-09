import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ucardtemp/Scenes/MinePage/Modules/SafeChain/SafeChainAdd/SafeChainAddBuilder.dart';

class SafeChainListRouter {
  showAddSafeChainPage(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => SafeChainAddBuilder(null).scene));
  }
}
