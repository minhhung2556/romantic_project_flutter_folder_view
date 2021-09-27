import 'package:flutter/material.dart';
import 'package:flutter_folder_view/src/common/index.dart';

class BooleanOption extends StatefulWidget {
  final bool value;
  final Function(bool value)? onChanged;
  final IconData falseIcon;
  final IconData trueIcon;

  const BooleanOption({
    Key? key,
    this.value: false,
    this.onChanged,
    required this.falseIcon,
    required this.trueIcon,
  }) : super(key: key);

  @override
  _BooleanOptionState createState() => _BooleanOptionState();
}

class _BooleanOptionState extends State<BooleanOption> {
  late bool _value;

  @override
  void initState() {
    _value = widget.value;
    super.initState();
  }

  @override
  void didUpdateWidget(covariant BooleanOption oldWidget) {
    if (oldWidget.value != widget.value) {
      setState(() {
        _value = widget.value;
      });
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return DeFaultFlatButton(
      onPressed: () {
        setState(() {
          _value = !_value;
          if (widget.onChanged != null) {
            widget.onChanged!(_value);
          }
        });
      },
      child: Center(
        child: Icon(
          _value ? widget.trueIcon : widget.falseIcon,
          color: kBodyTextColor,
        ),
      ),
    );
  }
}
