import 'package:flutter/material.dart';

class CustomTabBar extends StatefulWidget {
  const CustomTabBar({required this.children, required this.tabs, super.key});

  final List<Widget> children;
  final List<Widget> tabs;

  @override
  _CustomTabBarState createState() => _CustomTabBarState();
}

class _CustomTabBarState extends State<CustomTabBar>
    with SingleTickerProviderStateMixin {
  late TabController _tabController = TabController(length: 2, vsync: this);

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 45.0,
          child: TabBar(
              controller: _tabController,
              labelColor: Colors.black,
              unselectedLabelColor: Colors.grey[500],
              tabs: widget.tabs),
        ),
        Expanded(
            child: TabBarView(
                controller: _tabController, children: widget.children))
      ],
    );
  }
}
