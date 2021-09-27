import 'dart:io';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_folder_view/src/index.dart';

class FolderView extends StatefulWidget {
  final Directory root;
  final Decoration? backgroundDecoration;
  final int Function(FileSystemEntity a, FileSystemEntity b)? compareFile;
  final ViewMode viewMode;
  final EdgeInsets padding;
  final bool previewVisible;
  final bool hiddenFilesVisible;

  const FolderView({
    Key? key,
    required this.root,
    this.backgroundDecoration,
    this.compareFile,
    this.viewMode: ViewMode.grid,
    this.padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
    this.previewVisible: true,
    this.hiddenFilesVisible: true,
  }) : super(key: key);

  @override
  _FolderViewState createState() => _FolderViewState();
}

class _FolderViewState extends State<FolderView> {
  var _paths = <Directory>[];
  late ViewMode _viewMode;
  late bool _previewVisible;
  late bool _hiddenFilesVisible;

  @override
  void initState() {
    _paths.add(widget.root);
    _viewMode = widget.viewMode;
    _previewVisible = widget.previewVisible;
    _hiddenFilesVisible = widget.hiddenFilesVisible;
    super.initState();
  }

  @override
  void didUpdateWidget(covariant FolderView oldWidget) {
    bool needUpdate = false;
    if (oldWidget.root != widget.root) {
      _paths.clear();
      _paths.add(widget.root);
      needUpdate = true;
    }
    if (oldWidget.viewMode != widget.viewMode) {
      _viewMode = widget.viewMode;
      needUpdate = true;
    }
    if (oldWidget.previewVisible != widget.previewVisible) {
      _previewVisible = widget.previewVisible;
      needUpdate = true;
    }
    if (oldWidget.hiddenFilesVisible != widget.hiddenFilesVisible) {
      _hiddenFilesVisible = widget.hiddenFilesVisible;
      needUpdate = true;
    }
    if (needUpdate) {
      setState(() {});
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return !_onUserBack();
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: kPathViewHeight,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                    child: DefaultPathView(
                        onPressed: _onUserPressedPathItem, paths: _paths)),
                AspectRatio(
                  child: BooleanOption(
                    value: _previewVisible,
                    falseIcon: Icons.insert_drive_file_outlined,
                    trueIcon: Icons.insert_drive_file,
                    onChanged: (value) {
                      setState(() {
                        _previewVisible = value;
                      });
                    },
                  ),
                  aspectRatio: 1.0,
                ),
                AspectRatio(
                  child: BooleanOption(
                    value: _hiddenFilesVisible,
                    falseIcon: Icons.visibility_off,
                    trueIcon: Icons.visibility,
                    onChanged: (value) {
                      setState(() {
                        _hiddenFilesVisible = value;
                      });
                    },
                  ),
                  aspectRatio: 1.0,
                ),
                AspectRatio(
                  child: ViewModeOption(
                    mode: _viewMode,
                    onChanged: (value) {
                      setState(() {
                        _viewMode = value;
                      });
                    },
                  ),
                  aspectRatio: 1.0,
                ),
              ],
            ),
          ),
          Expanded(
            child: Stack(
              fit: StackFit.expand,
              children: _paths
                  .map(
                    (w) => Container(
                      decoration: widget.backgroundDecoration ??
                          BoxDecoration(color: Colors.white),
                      child: FutureBuilder<List<FileSystemEntity>>(
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            if (snapshot.data!.isNotEmpty) {
                              final length = snapshot.data!.length;
                              if (_viewMode == ViewMode.grid) {
                                return GridView.builder(
                                  padding: widget.padding,
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                    mainAxisExtent: kGridFileIconSize +
                                        kNameTextStyle.fontSize! * 2,
                                    mainAxisSpacing: 12,
                                    crossAxisSpacing: 12,
                                  ),
                                  itemCount: length,
                                  itemBuilder: (context, index) {
                                    var file = snapshot.data![index];
                                    return _itemBuild(context, index, file);
                                  },
                                );
                              } else {
                                return ListView.builder(
                                  padding: widget.padding,
                                  itemCount: length,
                                  itemBuilder: (context, index) {
                                    var file = snapshot.data![index];
                                    return Padding(
                                      padding: EdgeInsets.only(
                                          top: index == 0 ? 0 : 12),
                                      child: _itemBuild(context, index, file),
                                    );
                                  },
                                );
                              }
                            } else {
                              return EmptyIndicator();
                            }
                          } else if (snapshot.hasError) {
                            return ErrorIndicator();
                          } else {
                            return LoadingIndicator();
                          }
                        },
                        future: _handleDirectoryChildren(),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _itemBuild(BuildContext context, int index, FileSystemEntity file) {
    return DefaultFileItem(
      file: file,
      onPressed: _onUserPressedFile,
      viewMode: _viewMode,
      previewVisible: _previewVisible,
    );
  }

  bool _onUserPressedFile(BuildContext context, FileSystemEntity root) {
    if (root is Directory) {
      setState(() {
        _paths.add(root);
      });
      return true;
    } else {
      return false;
    }
  }

  bool _onUserBack() {
    if (_paths.length == 1) {
      return false;
    } else {
      setState(() {
        var current = _paths.removeLast();
        debugPrint('_FolderViewState._onBack: $current');
      });
      return true;
    }
  }

  bool _onUserPressedPathItem(
      BuildContext context, FileSystemEntity folder, int index) {
    print('_FolderViewState._onPressedPathItem: $index');
    if (index >= 0 && index < _paths.length - 1) {
      setState(() {
        _paths = _paths.sublist(0, math.max(index + 1, 1));
      });
      return true;
    } else {
      return false;
    }
  }

  Future<List<FileSystemEntity>> _handleDirectoryChildren() async {
    var children = await loadDirectoryChildren(_paths.last);

    if (!_hiddenFilesVisible) {
      children.removeWhere((element) => element.isHidden);
    }

    return children;
  }
}
