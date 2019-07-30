import 'package:discover_deep_cove/widgets/misc/body_text.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LoadingModalOverlay extends StatelessWidget{
  final String loadingMessage;
  final Icon icon;

  LoadingModalOverlay({@required this.loadingMessage, this.icon});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Opacity(
          opacity: 0.9,
          child: const ModalBarrier(
            dismissible: false,
            color: Colors.black,
          ),
        ),
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              icon ?? CircularProgressIndicator(),
              SizedBox(height: 50),
              BodyText(
                 loadingMessage,
                align: TextAlign.center,
              ),
            ],
          ),
        ),
      ],
    );
  }
}