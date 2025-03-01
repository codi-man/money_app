import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool isHomePage;
  const CustomAppBar({super.key, this.isHomePage = false});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: 100,
      backgroundColor: Colors.white,
      centerTitle: true,
      leading: isHomePage ? const Icon(Icons.menu)
      :IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      title: Row(
        children: [
          Image.asset(
            "assets/logos/logo_white.png",
            height: 70,
            color: const Color.fromARGB(255, 37, 113, 226),
          )
        ],
      ),
      actions: const [
        CircleAvatar(
          backgroundImage: AssetImage(
            'assets/images/profile_picture.jpg',
          ),
          radius: 30,
        ),
        SizedBox(width: 16),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(100);
}
