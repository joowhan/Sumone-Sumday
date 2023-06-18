import 'package:flutter/material.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final AppBar appBar;
  final String title;

  const MyAppBar({
    super.key,
    required this.title,
    required this.appBar,
  });

  @override
  Size get preferredSize => Size.fromHeight(appBar.preferredSize.height);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: const Icon(
          Icons.chevron_left,
          color: Colors.black,
          size: 36,
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      title: Text(
        title,
        style: const TextStyle(color: Colors.black, fontSize: 24),
      ),
      backgroundColor: Colors.white,
      elevation: 0.5,
    );
  }
}
