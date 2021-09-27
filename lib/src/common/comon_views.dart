import 'package:flutter/material.dart';

const double kPathViewHeight = 48;
const double kFileIconSize = 44;
const double kGridFileIconSize = 72;
const double kScreenIconSize = 128;
const TextStyle kNameTextStyle = TextStyle(
  fontSize: 12,
  color: kBodyTextColor,
);
const Color kBodyTextColor = Colors.black87;
const Color kFolderColor = Colors.orangeAccent;
const Color kFileColor = Colors.orangeAccent;
const Color kHiddenColor = Colors.grey;
const Color kErrorColor = Colors.redAccent;

class DeFaultFlatButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget child;

  const DeFaultFlatButton({
    Key? key,
    this.onPressed,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: child,
      style: ButtonStyle(
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(borderRadius: BorderRadius.zero)),
        padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.zero),
        elevation: MaterialStateProperty.all<double>(0.0),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent),
        minimumSize: MaterialStateProperty.all<Size>(Size.zero),
        overlayColor: MaterialStateProperty.all<Color>(
            Theme.of(context).primaryColor.withOpacity(0.5)),
      ),
    );
  }
}
