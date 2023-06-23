import 'package:flutter_project_frontend/views/home.dart';
import 'package:flutter_project_frontend/views/home_scaffold.dart';
//import 'package:flutter_project_frontend/views/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';

class MobileLayout extends StatefulWidget {
  const MobileLayout({Key? key}) : super(key: key);

  @override
  State<MobileLayout> createState() => _MobileLayoutState();
}

class _MobileLayoutState extends State<MobileLayout> {
  Widget mainComponent = Home();
  setMainComponent(Widget component) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => Scaffold(
                appBar: AppBar(
                  title: Text(component.toString()),
                  actions: [
                    IconButton(
                        icon: const Icon(Icons.home),
                        tooltip: 'Home',
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HomeScaffold()));
                        })
                  ],
                  backgroundColor:
                      Theme.of(context).navigationBarTheme.backgroundColor,
                ),
                body: component,
              )),
    );
    // setState(() {
    //   mainComponent = component;
    //   pageController.jumpToPage(5);
    //   appBarTitle = getTranslated(context, component.toString())!;
    // });
  }

  final LocalStorage storage = LocalStorage('BookHub');
  int _selectedIndex = 0;
  PageController pageController = PageController();
  String appBarTitle = 'Home';
  var views = ["Home", "Club", "Event", "Chat", "Perfil"];

  void onTapped(int index) {
    setState(() {
      _selectedIndex = index;
      appBarTitle = views[index];
    });
    pageController.jumpToPage(index);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    appBarTitle = "home";
    views = ["home", "clubTitle", "eventTitle", "chatTitle", "profile"];
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(appBarTitle),
          backgroundColor: Theme.of(context).navigationBarTheme.backgroundColor,
          automaticallyImplyLeading: false),
      bottomNavigationBar: BottomNavigationBar(
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: const Icon(Icons.home), label: 'home'),
            BottomNavigationBarItem(
                icon: Icon(Icons.group), label: 'clubTitle'),
            BottomNavigationBarItem(
                icon: const Icon(Icons.event), label: 'eventTitle'),
            BottomNavigationBarItem(
                icon: const Icon(Icons.chat), label: 'chatTitle'),
            BottomNavigationBarItem(
                icon: const Icon(Icons.face), label: 'profile')
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Theme.of(context).backgroundColor,
          unselectedItemColor: Theme.of(context).primaryColor,
          selectedIconTheme: Theme.of(context).iconTheme,
          unselectedIconTheme: Theme.of(context).iconTheme,
          onTap: onTapped),
      body: PageView(controller: pageController, children: [
        Home(setMainComponent: setMainComponent),
        //ClubList(setMainComponent: setMainComponent),
        //EventList(setMainComponent: setMainComponent),
        //ChatList(setMainComponent: setMainComponent),
        //SettingPage(),
        mainComponent,
      ]),
    );
  }
}
