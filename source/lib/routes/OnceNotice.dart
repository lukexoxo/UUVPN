// OnceNotice.dart
//ignore_for_file: file_names
import 'package:uuvpn/pages/ProOnecePage.dart';

import 'package:flutter/material.dart';

class OnceNotice extends StatelessWidget {
  const OnceNotice({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        actions: const [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: CloseButton(),
          )
        ],
      ),
      body: const ProOnecePage(),
    );
  }
}
