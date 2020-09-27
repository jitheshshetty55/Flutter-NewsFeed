import 'package:flutter/material.dart';
import 'dart:math';
import 'package:vector_math/vector_math.dart' show radians;
import '../pages/feed_item_list_page.dart';
import '../../blocs/feed_item_bloc.dart';
import '../custom_widgets/feed_item_swiper_list.dart';
import '../custom_widgets/feed_item_swipeup.dart';
import '../../utils/constants.dart';
import '../../models/feed_item_details.dart';

//Menu used for showing different modes of UI for displaying the feed list
class ModeMenu extends StatefulWidget {
  //instance of ModeMenu for Singleton pattern
  static final ModeMenu _instance = ModeMenu._internalModeMenu();

  //creating singleton of ModeMenu
  factory ModeMenu() => _instance;

  FeedListState _feedListState;
  List<FeedItemDetails> _feedItemList;
  FeedItemBloc _feedItemBloc = FeedItemBloc();

  String _currentFeedListView;

  ModeMenu._internalModeMenu() {
    _currentFeedListView = Constants.MODE_MENU_CAROUSAL;
    _feedItemBloc = FeedItemBloc();
  }

  getCurrentFeedListView() => _currentFeedListView;
  getFeedListState() => _feedListState;

  setFeedListState(FeedListState state) {
    this._feedListState = state;
  }

  setFeedItemData(List<FeedItemDetails> itemList) {
    this._feedItemList = itemList;
  }

  // Added by SKR
  getFeedItemData() => _feedItemList;

  @override
  _ModeMenuState createState() => _ModeMenuState();

  loadFeedItemView() {
    switch (_currentFeedListView) {
      case Constants.MODE_MENU_CAROUSAL:
        {
          return FeedItemSwiper(_feedItemList, _feedListState);
        }
        break;

      case Constants.MODE_MENU_GRID:
        {
    return FeedtinderSwiper(_feedItemList, _feedListState);

        }
        break;


      case Constants.MODE_MENU_GRID_LIST:
        {
          return Container();
        }
        break;
      case Constants.MODE_MENU_CLEAR:
        {
          print("Clicked the X button");
          return Container();
        }
        break;
    }
  }
  }



class _ModeMenuState extends State<ModeMenu>
    with SingleTickerProviderStateMixin, Constants {
  AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(duration: Duration(milliseconds: 1200), vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return RadialAnimation(controller: controller);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}

class RadialAnimation extends StatelessWidget {
  final ModeMenu modeMenu = ModeMenu();

  RadialAnimation({Key key, this.controller})
      : translation = Tween<double>(
    begin: 0.0,
    end: 100.0,
  ).animate(
    CurvedAnimation(parent: controller, curve: Curves.elasticOut),
  ),
        scale = Tween<double>(
          begin: 1.25,
          end: 0.0,
        ).animate(
          CurvedAnimation(parent: controller, curve: Curves.fastOutSlowIn),
        ),
        rotation = Tween<double>(
          begin: 0.0,
          end: 360.0,
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: Interval(
              0.0,
              0.7,
              curve: Curves.decelerate,
            ),
          ),
        ),
        super(key: key);

  final AnimationController controller;
  final Animation<double> rotation;
  final Animation<double> translation;
  final Animation<double> scale;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: controller,
        builder: (context, widget) {
          return Transform.rotate(
              angle: radians(rotation.value),
              child: Stack(alignment: Alignment.center, children: <Widget>[
                _buildButton(0,
                    color: Theme.of(context).primaryColor,
                    icon: Icons.collections,
                    tag: Constants.MODE_MENU_GRID),
                _buildButton(180,
                    color: Theme.of(context).primaryColor,
                    icon: Icons.view_carousel,
                    tag: Constants.MODE_MENU_CAROUSAL),
                Transform.scale(
                  scale: scale.value - 1,
                  child: FloatingActionButton(
                    heroTag: Constants.MODE_MENU_OPEN,
                    child: Icon(
                      Icons.close,
                    ),
                    onPressed: _close,
                    elevation: 0,
                  ),
                ),
                Transform.scale(
                  scale: scale.value,
                  child: FloatingActionButton(
                      heroTag: Constants.MODE_MENU_CLOSE,
                      child: Icon(
                        Icons.ac_unit,
                      ),
                      onPressed: _open,
                      elevation: 0),
                )
              ]));
        });
  }

  _open() {
    controller.forward();
  }

  _close() {
    controller.reverse();
    print("Close");
  }

  _buildButton(double angle, {Color color, IconData icon, String tag}) {
    final double rad = radians(angle);
    return Transform(
        transform: Matrix4.identity()
          ..translate(
              (translation.value) * cos(rad), (translation.value) * sin(rad)),
        child: FloatingActionButton(
            heroTag: tag,
            child: Icon(icon),
            backgroundColor: color,
            onPressed: () {
              modeMenu.getFeedListState().setState(() {
                modeMenu._currentFeedListView = Constants.MODE_MENU_CLEAR;
                modeMenu.loadFeedItemView();
                controller.reverse();
              });
              Future.delayed(Duration(milliseconds: 50), () {
                modeMenu.getFeedListState().setState(() {
                  print("Tag :  $tag");
                  modeMenu._currentFeedListView = tag;
                  modeMenu.loadFeedItemView();
                });
              });
            },
            elevation: 0));
  }
}

