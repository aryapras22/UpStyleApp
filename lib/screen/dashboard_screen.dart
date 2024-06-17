// ignore_for_file: use_build_context_synchronously, prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:upstyleapp/screen/chat/rooms_page.dart';
import 'package:upstyleapp/screen/home/home.dart';
import 'package:upstyleapp/screen/auth/profile_screen.dart';
import 'package:upstyleapp/screen/orders/order_screen.dart';

class DashboardScreen extends StatefulWidget {
  DashboardScreen({super.key, this.selectedIndex});
  int? selectedIndex;

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late int _selectedIndex;
  final List<Widget> _widgetOptions = <Widget>[
    Home(),
    OrderScreen(),
    RoomsPage(),
    ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    _selectedIndex = widget.selectedIndex ?? 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Image.asset('assets/icons/home.png'),
            label: 'Home',
            activeIcon: Image.asset('assets/icons/home_active.png'),
          ),
          // order
          BottomNavigationBarItem(
            icon: Image.asset('assets/icons/order.png'),
            label: 'Order',
            activeIcon: Image.asset('assets/icons/order_active.png'),
          ),
          // chat
          BottomNavigationBarItem(
            icon: Image.asset('assets/icons/chat.png'),
            label: 'Chat',
            activeIcon: Image.asset('assets/icons/chat_active.png'),
          ),
          // profile
          BottomNavigationBarItem(
            icon: Image.asset('assets/icons/profile.png'),
            label: 'Profile',
            activeIcon: Image.asset('assets/icons/profile_active.png'),
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        elevation: 10,
      ),
    );
  }
}
