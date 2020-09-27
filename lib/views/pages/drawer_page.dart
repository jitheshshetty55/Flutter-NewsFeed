import 'package:flutter/material.dart';
import 'package:hidden_drawer_menu/hidden_drawer/hidden_drawer_menu.dart';
import '../custom_widgets/drawer_menu.dart';
import '../pages/home_page.dart';
import '../../blocs/feed_category_bloc.dart';
import '../../utils/constants.dart';


class DrawerScreen extends StatefulWidget {

  @override
  _DrawerScreenState createState() => _DrawerScreenState();
}

class _DrawerScreenState extends State<DrawerScreen>  with  Constants {

  String _selectedMenu = Constants.FILTER_PROPERTY_ALL;
  FeedCategoryBloc _feedCategoryBloc = FeedCategoryBloc();

  @override
  void initState() {
    super.initState();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SimpleHiddenDrawer(
        menu: DrawerMenu(_selectedMenu),
        screenSelectedBuilder: (position, controller) {
          Widget screenCurrent;
          switch (position) {
            case 0:
              screenCurrent = Container(
                color: Colors.red,
              );
              break;
            case 1:
              screenCurrent = Container(
                color: Colors.green,
              );
              break;
            case 2:
              screenCurrent = Container(
                color: Colors.yellow,
              );
              break;
          }

          return Scaffold(
            body: Stack(
              children: <Widget>[
                HomeScreen(),
                StreamBuilder(
                  stream: _feedCategoryBloc.currentSelectedTab,
                  initialData: 1,
                  builder: (context,AsyncSnapshot<int> snapshot) {
                    return _createAppBar(snapshot.data, controller);
                  },),

              ],
            ),
          );
        },
      ),
    );
  }
  //Creating the App Bar for showing menu based on the selected tab
  Widget _createAppBar(int currentTab, var controller){
    if(currentTab == 1){
     return Container(
        height: 120,
        width: 100,
        child: AppBar(
          automaticallyImplyLeading: false,
          leading: IconButton(
              icon: Icon(Icons.menu),
              color: Colors.white,
              onPressed: () {
                controller.toggle();
              }),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
      );

    }else{
      return Container();
    }
  }
}
