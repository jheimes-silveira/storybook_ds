import 'package:easy_sidemenu/easy_sidemenu.dart';
import 'package:example/button_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  SideMenuController menuController = SideMenuController();
  PageController pageController = PageController();
  late List<SideMenuItem> items;

  @override
  void initState() {
    super.initState();

    items = [
      SideMenuItem(
        priority: 0,
        title: 'Button',
        onTap: (index, _) {
          menuController.changePage(index);
          pageController.jumpToPage(index);
        },
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SideMenu(
            controller: menuController,
            items: items,
          ),
          Expanded(
            child: PageView(
              controller: pageController,
              children: const [
                ButtonPage(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
