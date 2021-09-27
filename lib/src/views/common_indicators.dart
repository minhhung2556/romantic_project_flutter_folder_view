import 'package:flutter/material.dart';
import 'package:flutter_folder_view/flutter_folder_view.dart';

class EmptyIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Icon(
        Icons.folder_open_outlined,
        size: kScreenIconSize,
        color: kFolderColor,
      ),
    );
  }
}

class LoadingIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(),
    );
  }
}

class ErrorIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Icon(
        Icons.error_outline,
        size: kScreenIconSize,
        color: kErrorColor,
      ),
    );
  }
}
