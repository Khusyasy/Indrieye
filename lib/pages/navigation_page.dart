import 'package:flutter/material.dart';
import 'package:indrieye/views/obstacle_view.dart';
import 'package:indrieye/views/reader_view.dart';

class NavigationPage extends StatefulWidget {
  const NavigationPage({Key? key}) : super(key: key);

  @override
  State<NavigationPage> createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    IconButton(
                      onPressed: () =>
                          Navigator.pushNamed(context, "/settings"),
                      icon: const Icon(Icons.account_circle),
                    ),
                    const Expanded(
                      child: TabBar(
                        dividerHeight: 0,
                        tabs: [
                          Tab(text: 'DETEKSI RINTANGAN'),
                          Tab(text: 'BACA TEKS'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const Expanded(
                child: TabBarView(
                  physics: NeverScrollableScrollPhysics(),
                  children: [
                    ObstacleView(),
                    ReaderView(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
