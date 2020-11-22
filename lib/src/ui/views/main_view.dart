import 'dart:math';

import 'package:flutter/material.dart';
import 'package:md2_tab_indicator/md2_tab_indicator.dart';
import 'package:pokeroute/src/ui/views/current_spot_view.dart';
import 'package:pokeroute/src/ui/views/list_spot_entries_view.dart';
import 'package:intl/intl.dart';
import 'package:pokeroute/src/ui/views/list_spots_view.dart';
import 'package:responsive/flex_widget.dart';
import 'package:responsive/responsive.dart';
import 'package:responsive/responsive_row.dart';

class MainView extends StatefulWidget {
  static final DateTime now = DateTime.now();

  @override
  _MainViewState createState() => _MainViewState();
}

class _MainViewState extends State<MainView> with TickerProviderStateMixin {
  final String formattedDate =
      DateFormat('kk:mm:ss \n EEE d MMM').format(MainView.now);

  TabController _tabController;

  List<String> teams = ["instinct", "mystic", "valor"];
  String team;

  @override
  void initState() {
    _tabController = TabController(vsync: this, length: 2, initialIndex: 0);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var isMobile =
        Responsive.gridSize(MediaQuery.of(context).size.width) < Responsive.md;
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    team = teams[Random().nextInt(3)];

    return Container(
        child: Stack(
      children: <Widget>[
        Container(color: Colors.grey.shade600),
        Align(
          alignment: Alignment.center,
          child: isMobile
              ? Image(
                  width: screenWidth * 0.7,
                  height: screenHeight * 0.7,
                  image: AssetImage("page_backgrounds/pokeball.png"),
                  fit: BoxFit.contain)
              : Image(
                  height: screenHeight,
                  width: screenWidth,
                  image: AssetImage("page_backgrounds/team_$team.jpg"),
                  fit: BoxFit.cover),
        ),
        Container(
          color: isMobile ? Colors.transparent : Color.fromRGBO(0, 0, 0, 0.4),
        ),
        Scaffold(
            backgroundColor: Colors.transparent,
            body: Stack(children: <Widget>[
              LayoutBuilder(builder: (context, constraints) {
                if (Responsive.gridSize(constraints.maxWidth) >=
                    Responsive.md) {
                  return getDesktopLayout(context);
                } else {
                  return getMobileLayout();
                }
              }),
            ]),
            bottomNavigationBar: Align(
                heightFactor: 1,
                alignment: Alignment.bottomCenter,
                child:
                    //
                    ResponsiveRow(
                        columnsCount: 12,
                        runAlignment: WrapAlignment.end,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: <Widget>[
                      FlexWidget(
                        child: CurrentSpotView(),
                        xs: 12,
                        sm: 10,
                        md: 8,
                        lg: 8,
                        xl: 8,
                      ),
                    ])))
      ],
    ));
  }

  Widget getDesktopLayout(BuildContext context) {
    final columnHeight = MediaQuery.of(context).size.height * 0.8;

    return Center(
      child: ResponsiveRow(
          columnsCount: 12,
          runAlignment: WrapAlignment.end,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: <Widget>[
            FlexWidget(
              child: Container(
                constraints: BoxConstraints(maxHeight: columnHeight),
                child: ListSpotEntriesView(),
              ),
              md: 6,
              lg: 6,
              xl: 6,
            ),
            FlexWidget(
              child: Container(
                constraints: BoxConstraints(maxHeight: columnHeight),
                child: ListSpotsView(),
              ),
              md: 6,
              lg: 6,
              xl: 6,
            ),
          ]),
    );
  }

  Widget getMobileLayout() {
    return Column(
      children: <Widget>[
        TabBar(
            controller: _tabController,
            onTap: (index) {
              _tabController.animateTo(index);
            },
            labelStyle: TextStyle(fontWeight: FontWeight.w700),
            indicatorSize: TabBarIndicatorSize.tab,
            labelColor: Theme.of(context).primaryColor,
            unselectedLabelColor: Colors.white,
            indicator: MD2Indicator(
                indicatorHeight: 3,
                indicatorColor: Theme.of(context).primaryColor,
                indicatorSize: MD2IndicatorSize.full),
            tabs: [Tab(text: "SPOTS"), Tab(text: "ROUTE")]),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: <Widget>[ListSpotEntriesView(), ListSpotsView()],
          ),
        )
      ],
    );
  }
}
