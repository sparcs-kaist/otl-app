import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:otlplus/constants/color.dart';

class DeleteDialog extends StatelessWidget {
  const DeleteDialog({Key? key, required this.text, this.onDelete})
      : super(key: key);
  final String text;
  final void Function()? onDelete;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Material(
          child: IntrinsicWidth(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.fromLTRB(16, 19, 16, 20),
                  alignment: Alignment.center,
                  color: Colors.white,
                  child: Text(
                    text,
                    style: TextStyle(
                      fontSize: 12,
                    ),
                  ),
                ),
                Row(
                  children: [
                    _buildButton(
                      () => Navigator.pop(context),
                      text: 'common.cancel'.tr(),
                      buttonColor: OTLColor.grayE,
                    ),
                    _buildButton(
                      () {
                        if (onDelete != null) onDelete!();
                        Navigator.pop(context);
                      },
                      text: 'common.delete'.tr(),
                      buttonColor: OTLColor.pinksMain,
                      textColor: Colors.white,
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildButton(
    void Function()? onTap, {
    required String text,
    required Color buttonColor,
    Color? textColor,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 40,
          alignment: Alignment.center,
          color: buttonColor,
          child: Text(
            text,
            style: TextStyle(
              color: textColor,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}
