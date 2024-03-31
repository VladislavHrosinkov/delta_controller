import 'package:admin/controllers/SerialController.dart';
import 'package:admin/controllers/SettingsProvider.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';

/// Screen that shows an example of openFile
class FileAccessWidget extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    SettingsProvider settingsProvider = context.watch<SettingsProvider>();
    SerialController serialController = context.watch<SerialController>();

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
          ),
          child: const Text('Press to open an instruction file'),
          onPressed: () => _openTextFile(context, settingsProvider,serialController),
        ),
      ],
    );
  }

   Future<void> _openTextFile(BuildContext context, SettingsProvider settingsProvider, SerialController serialController) async {
    const XTypeGroup typeGroup = XTypeGroup(
      label: 'text',
    );


    // This demonstrates using an initial directory for the prompt, which should
    // only be done in cases where the application can likely predict where the
    // file would be. In most cases, this parameter should not be provided.
    String? initialDirectory = settingsProvider.currentDir;
    final XFile? file = await openFile(
      acceptedTypeGroups: <XTypeGroup>[typeGroup],
      initialDirectory: initialDirectory,
    );
    if (file == null) {
      // Operation was canceled by the user.
      return;
    }
    //final String fileName = basename(file.path);
    settingsProvider.saveDir(dirname(file.path));
    final String fileContent = await file.readAsString();
    serialController.sendReplay(fileContent);
  }
}

class LoadPath extends StatelessWidget {
  const LoadPath({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FileAccessWidget(),
      ]
    );
  }
}