import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_folder_view/flutter_folder_view.dart';
import 'package:flutter_folder_view/src/common/index.dart';
import 'package:flutter_folder_view/src/views/index.dart';

class DefaultFileItem extends StatelessWidget {
  final Function(BuildContext context, FileSystemEntity file) onPressed;
  final FileSystemEntity file;
  final ViewMode viewMode;
  final bool previewVisible;

  const DefaultFileItem({
    Key? key,
    required this.file,
    required this.onPressed,
    required this.viewMode,
    required this.previewVisible,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DeFaultFlatButton(
      onPressed: () {
        onPressed(context, file);
      },
      child: Padding(
        padding: EdgeInsets.all(4.0),
        child: viewMode == ViewMode.grid
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(child: _buildIcon()),
                  Padding(
                    padding: const EdgeInsets.only(top: 12.0),
                    child: _buildName(),
                  ),
                ],
              )
            : Row(
                children: [
                  _buildIcon(Colors.white),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 12.0),
                      child: _buildName(),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildIcon([Color? background]) {
    final isHidden = file.isHidden;
    final isDirectory = file is Directory;

    if (!isDirectory && previewVisible && file.isImage) {
      return Container(
        color: background,
        width: kFileIconSize,
        height: kFileIconSize,
        child: Image.file(
          file as File,
          cacheWidth: kFileIconSize.round(),
          cacheHeight: kFileIconSize.round(),
          fit: BoxFit.fitHeight,
        ),
      );
    } else {
      return Icon(
        isDirectory ? Icons.folder : Icons.insert_drive_file,
        color:
            isHidden ? kHiddenColor : (isDirectory ? kFolderColor : kFileColor),
        size: viewMode == ViewMode.list ? kFileIconSize : kGridFileIconSize,
      );
    }
  }

  Widget _buildName() {
    final name = file.name;
    final extension = file.extension;
    final isHidden = file.isHidden;
    final isDirectory = file is Directory;

    return Row(
      children: [
        Expanded(
          child: Text(
            name,
            maxLines: 1,
            textAlign:
                viewMode == ViewMode.list ? TextAlign.start : TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style:
                kNameTextStyle.copyWith(color: isHidden ? kHiddenColor : null),
          ),
        ),
        if (!isDirectory && extension.isNotEmpty)
          Text(
            '.$extension',
            maxLines: 1,
            textAlign:
                viewMode == ViewMode.list ? TextAlign.start : TextAlign.center,
            style:
                kNameTextStyle.copyWith(color: isHidden ? kHiddenColor : null),
          ),
      ],
    );
  }
}
