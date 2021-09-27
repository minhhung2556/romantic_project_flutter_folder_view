import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_folder_view/src/common/index.dart';

class DefaultPathView extends StatelessWidget {
  final Function(BuildContext context, FileSystemEntity folder, int index)
      onPressed;
  final List<FileSystemEntity> paths;

  const DefaultPathView({
    Key? key,
    required this.onPressed,
    required this.paths,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) {
        return DeFaultFlatButton(
          onPressed: () {
            onPressed(context, paths[index], index);
          },
          child: Padding(
            padding: EdgeInsets.only(
                left: 16, right: index < paths.length - 1 ? 0 : 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  paths[index].name,
                  maxLines: 1,
                  overflow: TextOverflow.fade,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.black87,
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  color: Colors.black54,
                ),
              ],
            ),
          ),
        );
      },
      itemCount: paths.length,
      scrollDirection: Axis.horizontal,
    );
  }
}
