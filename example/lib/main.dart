import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_folder_view/flutter_folder_view.dart';
import 'package:path_provider_ex/path_provider_ex.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double value = 0;
  final valueTween = Tween<double>(begin: -120, end: 120);
  Directory? directory;
  @override
  void initState() {
    loadDir();
    super.initState();
  }

  void loadDir() async {
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      status = await Permission.storage.request();
    }
    if (!status.isGranted) return;

    var storage = await PathProviderEx.getStorageInfo();
    setState(() {
      directory = Directory(storage[0].rootDir);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Folder View'),
      ),
      body: directory == null
          ? null
          : FolderView(
              root: directory!,
            ),
    );
  }
}
