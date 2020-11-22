import 'package:clipboard/clipboard.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:md2_tab_indicator/md2_tab_indicator.dart';
import 'package:pokeroute/locator.dart';
import 'package:pokeroute/src/core/services/route_service.dart';
import 'package:pokeroute/src/core/viewmodels/current_spot_model.dart';
import 'package:pokeroute/src/ui/views/base_view.dart';
import 'package:pokeroute/src/ui/widgets/distance_bar_widget.dart';

class CurrentSpotView extends StatefulWidget {
  CurrentSpotView({Key key}) : super(key: key);

  @override
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
          print(
              "[CurrentSpotView] New route: $routeHash -> ${model.routeHash}");
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
      clipBehavior: Clip.antiAlias,
      child: Container(
          child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
        Material(
          child:
              //  ExpandablePanel(
              //   header:
              Column(
            children: <Widget>[
              ListTile(
                leading:
                    // TODO: Change to animated pokeball for catching
                    model.hasRoute
                        ? IconButton(
                            tooltip: "Mark as caught",
                            icon: BaseView<CurrentSpotModel>(
                              builder: (context, model, child) {
                                return Icon(model.visited
                                    ? Icons.check_box
                                    : Icons.check_box_outline_blank);
                              },
                            ),
                            onPressed: () {
                              print("TODO: Implement catching");
                              model.setVisited(
                                  model.getSpot(model.idTargetLocation),
                                  !model.visited);
                            },
                          )
                        : null,
                title: routeService.hasRoute
                    ? TabBar(
                        key: Key("wohoo"),
                        controller: _tabController,
                        onTap: (index) {
                          model.idTargetLocation = model.spotsSorted[index].id;
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
                          style: Theme.of(context).textTheme.subtitle2,
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
              model.hasRoute
                  ? ListTile(
                      leading: IconButton(
                        icon: Icon(Icons.refresh),
                        tooltip: "Reset timer",
                        onPressed: () {
                          model.resetCooldown();
                        },
                      ),
                      title: DistanceBarWidget(),
                      trailing: IconButton(
                        icon: Icon(Icons.content_copy),
                        onPressed: () {
                          FlutterClipboard.copy(
                            model
                                .getSpot(model.idTargetLocation)
                                .coordinates
                                .toString(),
                          );
                        },
                      ),
                    )
                  : SizedBox.shrink(),
            ],
          ),
          // expanded: ExportGpx(),
          //   controller: controllerExpandable,
          // ),
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
