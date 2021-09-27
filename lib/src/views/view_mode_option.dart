import 'package:flutter/material.dart';
import 'package:flutter_folder_view/src/common/index.dart';

enum ViewMode { list, grid }

class ViewModeOption extends StatefulWidget {
  final ViewMode mode;
  final Function(ViewMode value)? onChanged;

  const ViewModeOption({
    Key? key,
    this.mode: ViewMode.grid,
    this.onChanged,
  }) : super(key: key);

  @override
  _ViewModeOptionState createState() => _ViewModeOptionState();
}

class _ViewModeOptionState extends State<ViewModeOption> {
  late ViewMode _mode;

  @override
  void initState() {
    _mode = widget.mode;
    super.initState();
  }

  @override
  void didUpdateWidget(covariant ViewModeOption oldWidget) {
    if (oldWidget.mode != widget.mode) {
      setState(() {
        _mode = widget.mode;
      });
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return DeFaultFlatButton(
      onPressed: () {
        setState(() {
          if (_mode == ViewMode.grid) {
            _mode = ViewMode.list;
            if (widget.onChanged != null) {
              widget.onChanged!(_mode);
            }
          } else if (_mode == ViewMode.list) {
            _mode = ViewMode.grid;
            if (widget.onChanged != null) {
              widget.onChanged!(_mode);
            }
          }
        });
      },
      child: Center(
        child: Icon(
          _mode == ViewMode.grid ? Icons.grid_view : Icons.view_list,
          color: kBodyTextColor,
        ),
      ),
    );
  }
}
