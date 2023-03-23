import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NavigationAppBar extends StatefulWidget {
  const NavigationAppBar({super.key});

  @override
  State<NavigationAppBar> createState() => _NavigationAppBarState();
}

class _NavigationAppBarState extends State<NavigationAppBar> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      items: [
        BottomNavigationBarItem(
            icon: SvgPicture.asset(
              "assets/icons/appBar/home.svg",
              color: Colors.grey,
            ),
            activeIcon: SvgPicture.asset(
              "assets/icons/appBar/home.svg",
              color: Colors.black,
            ),
            label: 'Home'),
        BottomNavigationBarItem(
            icon: SvgPicture.asset(
              "assets/icons/appBar/calendar.svg",
              color: Colors.grey,
            ),
            activeIcon: SvgPicture.asset(
              "assets/icons/appBar/calendar.svg",
              color: Colors.black,
            ),
            label: 'Calendar'),
        BottomNavigationBarItem(
            icon: SvgPicture.asset(
              "assets/icons/appBar/messages1.svg",
              color: Colors.grey,
            ),
            activeIcon: SvgPicture.asset(
              "assets/icons/appBar/messages1.svg",
              color: Colors.black,
            ),
            label: 'Message'),
        BottomNavigationBarItem(
            icon: SvgPicture.asset(
              "assets/icons/appBar/note1.svg",
              color: Colors.grey,
            ),
            activeIcon: SvgPicture.asset(
              "assets/icons/appBar/note1.svg",
              color: Colors.black,
            ),
            label: 'Note'),
      ],
      currentIndex: _selectedIndex,
      selectedItemColor: Colors.black,
      unselectedItemColor: Colors.grey,
      onTap: (index) {
        _onItemTapped(index);
      },
    );
  }
}

class GroupingLogo extends StatelessWidget {
  const GroupingLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset("assets/images/logo.svg",
        semanticsLabel: 'Acme Logo');
  }
}
