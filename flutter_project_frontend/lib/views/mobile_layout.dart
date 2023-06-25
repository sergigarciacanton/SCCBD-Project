import 'package:flutter_project_frontend/views/home.dart';
import 'package:flutter_project_frontend/views/home_scaffold.dart';
//import 'package:flutter_project_frontend/views/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project_frontend/views/qr_scanner.dart';
import 'package:localstorage/localstorage.dart';

class MobileLayout extends StatefulWidget {
  const MobileLayout({Key? key}) : super(key: key);

  @override
  State<MobileLayout> createState() => _MobileLayoutState();
}

class _MobileLayoutState extends State<MobileLayout> {
  Widget mainComponent = const Home();
  setMainComponent(Widget component) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => Scaffold(
                appBar: AppBar(
                  title: Text(component.toString(),
                      style: const TextStyle(
                          color: Color.fromARGB(255, 0, 123, 192))),
                  actions: [
                    IconButton(
                        icon: const Icon(Icons.home),
                        tooltip: 'Home',
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const HomeScaffold()));
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

  final LocalStorage storage = LocalStorage('SCCBD');
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
    appBarTitle = "Home";
    views = ["Home", "QR Codes reader"];
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
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(
                icon: Icon(Icons.qr_code_2), label: 'QR Codes reader')
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Theme.of(context).backgroundColor,
          unselectedItemColor: Theme.of(context).primaryColor,
          selectedIconTheme: Theme.of(context).iconTheme,
          unselectedIconTheme: Theme.of(context).iconTheme,
          onTap: onTapped),
      body: PageView(controller: pageController, children: [
        Home(setMainComponent: setMainComponent),
        QRViewExample(setMainComponent: setMainComponent),
        mainComponent,
      ]),
    );
  }
}
