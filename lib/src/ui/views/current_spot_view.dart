import 'package:expandable/expandable.dart';
import 'package:flutter_web/material.dart';
import 'package:md2_tab_indicator/md2_tab_indicator.dart';
import 'package:pokeroutes/locator.dart';
import 'package:pokeroutes/src/core/services/route_service.dart';
import 'package:pokeroutes/src/core/viewmodels/current_spot_model.dart';
import 'package:pokeroutes/src/ui/views/base_view.dart';
import 'package:pokeroutes/src/ui/views/export_gpx.dart';
import 'package:pokeroutes/src/ui/widgets/distance_bar_widget.dart';

class CurrentSpotView extends StatefulWidget {
  CurrentSpotView({Key key}) : super(key: key);

  _CurrentSpotViewState createState() => _CurrentSpotViewState();
}

class _CurrentSpotViewState extends State<CurrentSpotView>
    with TickerProviderStateMixin {
  ExpandableController controllerExpandable;
  bool isExpanded = false;

  CurrentSpotModel model;

  RouteService routeService;
  String routeHash;

  TabController _tabController;

  @override
  void initState() {
    model = locator<CurrentSpotModel>();
    initializeTabController();

    routeService = locator<RouteService>();
    routeService.subscribe(() {
      print("[CurrentSpotView] Received update from RouteService.");

      if (routeHash != model.routeHash) {
        setState(() {
          print("[CurrentSpotView] New route: $routeHash -> ${model.routeHash}");
          initializeTabController();
          routeHash = model.routeHash;
        });
      }

      _tabController.animateTo(getActiveTabIndex());
    });

    controllerExpandable = ExpandableController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Card(
      child: Container(
          child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
        Material(
          child: ExpandablePanel(
            hasIcon: false,
            header: Column(
              children: <Widget>[
                ListTile(
                  leading:
                      // TODO: Change to animated pokeball for catching
                      IconButton(
                    icon: BaseView<CurrentSpotModel>(
                      builder: (context, model, child) {
                        return Icon(model.visited
                            ? Icons.check_box
                            : Icons.check_box_outline_blank);
                      },
                    ),
                    onPressed: () {
                      print("TODO: Implement catching");
                      model.setVisited(model.getSpot(model.idTargetLocation),
                          !model.visited);
                    },
                  ),
                  title: routeService.hasRoute
                      ? TabBar(
                          key: Key("wohoo"),
                          controller: _tabController,
                          onTap: (index) {
                            model.idTargetLocation =
                                model.spotsSorted[index].id;
                          },
                          labelStyle: TextStyle(fontWeight: FontWeight.w700),
                          indicatorSize: TabBarIndicatorSize.label,
                          labelColor: Color(0xff1a73e8),
                          unselectedLabelColor: Color(0xff5f6368),
                          isScrollable: true,
                          indicator: MD2Indicator(
                              indicatorHeight: 3,
                              indicatorColor: Color(0xff1a73e8),
                              indicatorSize: MD2IndicatorSize.full),
                          tabs: model.spotsSorted
                              .map((spot) => Tab(
                                  text: model.getSpot(spot.id).name.toString()))
                              .toList())
                      : Center(
                          child: Text(
                            "Add spots to see your route.",
                            style: Theme.of(context).textTheme.subtitle,
                          ),
                        ),
                  // TODO: Enable ExpandIcon & enable GPX downloading
                  // trailing: ExpandIcon(
                  //   isExpanded: isExpanded,
                  //   onPressed: (exp) {
                  //     setState(() {
                  //       controllerExpandable.toggle();
                  //       isExpanded = controllerExpandable.expanded;
                  //     });
                  //   },
                  // ),
                ),
                ListTile(
                    leading: IconButton(
                      icon: Icon(Icons.refresh),
                      onPressed: () {
                        model.resetCooldown();
                      },
                    ),
                    title: DistanceBarWidget(),
                    trailing: IconButton(
                        icon: Icon(Icons.content_copy),
                        onPressed: () {
                          print("TODO: Implement coordinate copying");
                        })),
              ],
            ),
            expanded: ExportGpx(),
            controller: controllerExpandable,
            tapHeaderToExpand: false,
          ),
        )
      ])),
    ));
    // });
  }

  void initializeTabController() {
    _tabController = TabController(
        vsync: this,
        length: model.spotsSorted.length,
        initialIndex: getActiveTabIndex());
    print("initializeTabController() | Created.");
  }

  int getActiveTabIndex() {
    try {
      return model.getSortedSpotIndex(model.idTargetLocation) ?? 0;
    } catch (e) {
      return 0;
    }
  }
}
