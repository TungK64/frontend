import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SettingLabel extends StatelessWidget {
  final String icon;
  final String label;
  final Function()? onTap;

  SettingLabel(this.icon, this.label, this.onTap);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return ListTile(
      onTap: onTap,
      title: Container(
        height: 60,
        constraints: const BoxConstraints(maxHeight: 60),
        padding:
            const EdgeInsets.only(left: 15, right: 10, top: 10, bottom: 10),
        margin: const EdgeInsets.only(top: 15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Color.fromARGB(255, 208, 229, 245),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SvgPicture.asset(
              icon,
              width: 22,
              height: 22,
            ),
            const SizedBox(
              width: 10,
            ),
            Text(label,
                style: TextStyle(fontSize: 16),
                overflow: TextOverflow.ellipsis),
            const Spacer(),
            const Icon(Icons.arrow_forward),
            const SizedBox(
              width: 10,
            )
          ],
        ),
      ),
    );
  }
}
