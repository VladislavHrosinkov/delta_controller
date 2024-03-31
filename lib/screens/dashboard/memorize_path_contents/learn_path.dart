import 'package:admin/controllers/SerialController.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LearnPath extends StatefulWidget {
  const LearnPath({Key? key}) : super(key: key);

  @override
  State<LearnPath> createState() => _LearnPathState();
}

class _LearnPathState extends State<LearnPath> {
  bool learning = false;
  String file = "learned_path";

  @override
  Widget build(BuildContext context) {
    SerialController serialController = context.watch<SerialController>();
    final RegExp _validFileName = RegExp(r'^[a-zA-Z0-9_\-\.]+$');

    return Container(
      child: Column(
        children: [
          TextField(
              onChanged: (val) {
                final firstMatch = _validFileName.firstMatch(val);
                if (firstMatch != null) {
                  file = val;
                }
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Enter file name"
              ),
          ),
          SizedBox(height: 10,),
          ElevatedButton(
            onPressed: () {
              if (learning) {
                serialController.sendEnd();
              } else {
                serialController.sendLearn(file);
              }
              setState(() {
                learning = !learning;
              });
            },
            child: Text(learning ? 'Stop learning': 'Start Learning a Path'),
            style: ElevatedButton.styleFrom(
                backgroundColor: learning ? Colors.red: Colors.blue,
                foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}