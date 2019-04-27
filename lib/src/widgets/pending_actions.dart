import 'package:flutter/material.dart';

class PendingAction extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Align(
          alignment: Alignment.center,
          child: Column(
            children: [
              CircularProgressIndicator(
                  valueColor: new AlwaysStoppedAnimation(Colors.black87)),
              SizedBox(
                height: 10.0,
              ),
              Text(
                'Loading',
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
            ],
            mainAxisAlignment: MainAxisAlignment.center,
          ),
        ),
        ModalBarrier(
          dismissible: false,
          color: Colors.transparent,
        ),
      ],
    );
  }
}
