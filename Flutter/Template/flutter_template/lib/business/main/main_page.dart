import 'package:flutter/material.dart';
import 'package:flutter_template/business/home/home_page.dart';
import 'package:flutter_template/business/my_center/user_page.dart';
import 'package:flutter_template/r.dart';
import 'package:bottom_tab_bar/bottom_tab_bar.dart';

class MainPage extends StatefulWidget {
  @override
  _MainState createState() => _MainState();
}

class _MainState extends State<MainPage> with SingleTickerProviderStateMixin {
  TabController _tabController;
  var _appBarTitles = ['首页', '我的'];
  var _pageList = [HomePage(), UserPage(null)];
  var _tarImages = [
    [
      Image.asset(
        R.assetsImageUnselectedhomePng,
        width: 24,
        height: 24,
        fit: BoxFit.fill,
      ),
      Image.asset(R.assetsImageSelectedhomePng,
          width: 24, height: 24, fit: BoxFit.fill),
    ],
    [
      Image.asset(
        R.assetsImageUnselectedmePng,
        width: 24,
        height: 24,
        fit: BoxFit.fill,
      ),
      Image.asset(R.assetsImageUnselectedmePng,
          width: 24, height: 24, fit: BoxFit.fill),
    ],
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
        length: _appBarTitles.length, vsync: this, initialIndex: 0);
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: SafeArea(
        top: false,
        bottom: true,
        child: Scaffold(
          body: TabBarView(
            controller: _tabController,
            physics: NeverScrollableScrollPhysics(),
            children: _pageList,
          ),
          bottomNavigationBar: BottomTabBar(
            items: getTabBarList(),
            onTap: _onItemSelected,
            currentIndex: _selectedIndex,
            type: BottomTabBarType.fixed,
          ),
        ),
      ),
    );
  }

  int _selectedIndex = 1;

  void _onItemSelected(int index) {
    setState(() {
      _selectedIndex = index;
      _tabController.animateTo(index);
    });

  }

  List<BottomTabBarItem> getTabBarList() {
    List<BottomTabBarItem> list = List();
    int index = 0;
    for (String title in _appBarTitles) {
      list.add(BottomTabBarItem(
          icon: _tarImages[index][0],
          activeIcon: _tarImages[index][1],
          title: Text(title)));
      index++;
    }
    return list;
  }
}
