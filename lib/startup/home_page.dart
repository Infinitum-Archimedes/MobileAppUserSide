// packages
import 'dart:async';
import 'package:flutter/material.dart';

// pages
import 'package:student_health_tracker/Account/account.dart';
import 'package:student_health_tracker/Settings/settings.dart';
import 'package:student_health_tracker/Samples/sample.dart';
import 'package:student_health_tracker/notification_center/notification_center.dart';
import '../globals/stream_signal.dart';
import '../globals/static/global_widgets.dart';
import 'package:student_health_tracker/notification_center/notification_page_router.dart';
import 'package:student_health_tracker/map_page/map_page.dart';
import 'package:student_health_tracker/chat/chat.dart';

/*
The main purpose of this class is to make the surrounding bars on the screen.
- makes the bottom navigation bar
- makes the top bar

Once signed in, this is the viewable page

*/
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  static StreamController<StreamSignal> homePageStream =
      StreamController<StreamSignal>();

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  PageController pageController = PageController(
    initialPage: 1,
  );

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  // setup for a navigation bar
  int pageIndex = 1;

  // builds 'home page' -> page which loads the main app
  @override
  Widget build(BuildContext context) {
    HomePage.homePageStream = StreamController();
    return StreamBuilder(
        stream: HomePage.homePageStream.stream,
        builder: (context, snapshot) {
          return Scaffold(
            body: PageView(
              physics: pageIndex == 0
                  ? const NeverScrollableScrollPhysics()
                  : const ClampingScrollPhysics(parent: PageScrollPhysics()),
              controller: pageController,
              onPageChanged: (index) {
                setState(() {
                  pageIndex = index;
                });
              },
              // list of active pages
              children: [
                const MapPage(),
                ChatScreen(),
              ],
            ),
            // Where Top Bar is defined
            appBar: AppBar(
              centerTitle: true,
              backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
              shadowColor: Theme.of(context).colorScheme.shadow,
              title: const Text("Student Health Tracker"),
              leading: IconButton(
                  onPressed: () {
                    setState(() {
                      Navigator.push(
                          context,
                          GlobalWidgets.swipePage(const Settings(),
                              title: 'Settings'));
                    });
                  },
                  icon: Icon(Icons.settings_outlined,
                      color: Theme.of(context).colorScheme.onSurface,
                      size: 27.5)),
              actions: [
                IconButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          GlobalWidgets.swipePage(NotificationPageRouter(),
                              title: 'Account'));
                    },
                    icon: Icon(Icons.person_outline,
                        color: Theme.of(context).colorScheme.onSurface,
                        size: 27.5)),
                const SizedBox(width: 10),
              ],
            ),
            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
            extendBody: true,
            bottomNavigationBar: _buildNavBar(context),
          );
        });
  }

  // builds the bottom navigation bar
  Widget _buildNavBar(BuildContext context) {
    double bottomPadding = MediaQuery.of(context).padding.bottom;
    return Container(
      height: 60 + bottomPadding,
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainer,
          // border radius rounds the bottom bar
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          boxShadow: [
            BoxShadow(
                color: Theme.of(context).colorScheme.shadow,
                spreadRadius: 1,
                blurRadius: 2)
          ]),
      padding: EdgeInsets.only(bottom: bottomPadding),
      // on click, changes page index and fills in the icon
      // doing this automatically updates the page that is displayed
      // uses a row, akin to the column in Detail, that allows multiple children to be laid in a row
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          // sets up icon buttons that on pressed, changes which page is active
          // additionally, on press changes from outlined to filled in
          _buildNavIcon(context, Icons.map, Icons.map_outlined, 0),
          _buildNavIcon(context, Icons.explore, Icons.explore_outlined, 1),
        ],
      ),
    );
  }

  Widget _buildNavIcon(
      BuildContext context, IconData icon1, IconData icon2, int index) {
    return IconButton(
        enableFeedback: false,
        onPressed: () {
          setState(() {
            pageController.animateToPage(
              index,
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeInOut,
            );
          });
        },
        icon: Icon(
          pageIndex == index ? icon1 : icon2,
          color: pageIndex == index
              ? Theme.of(context).colorScheme.onSurface
              : Theme.of(context).colorScheme.onSurfaceVariant,
          size: 32.5,
        ));
  }
} // class
