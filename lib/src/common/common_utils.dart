import 'dart:io';

const kImageFileExtensions = <String>['jpg', 'jpeg', 'png', 'gif'];

extension FileSystemEntityEx on FileSystemEntity {
  String get nameWithExtension {
    var p = this.path;
    if (p.endsWith(Platform.pathSeparator)) {
      p = p.substring(0, p.length - 1);
    }
    return p.substring(p.lastIndexOf(Platform.pathSeparator) + 1);
  }

  String get name {
    var n = nameWithExtension;
    if (this is Directory) {
      return n;
    } else {
      var i = n.lastIndexOf('.');
      if (i > 0) {
        return n.substring(0, i);
      } else
        return n;
    }
  }

  String get extension {
    var n = nameWithExtension;
    var i = n.lastIndexOf('.');
    if (i > -1 && i + 1 < n.length - 1) {
      var ext = n.substring(i + 1);
      // print('extension: $ext');
      return ext;
    } else
      return '';
  }

  bool get isHidden => name.startsWith('.');

  bool get isImage => kImageFileExtensions.contains(extension);
}

Future<List<FileSystemEntity>> loadDirectoryChildren(
    Directory directory) async {
  return directory.list().fold<List<FileSystemEntity>>(
      List<FileSystemEntity>.empty(growable: true),
      (previous, element) => previous..add(element));
}
