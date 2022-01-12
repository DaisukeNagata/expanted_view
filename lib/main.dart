import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'expanted_view.dart';

void main() {
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),

      home: new MyHomePage(title: 'Flutter Demo Home Page'),
      // home: new ExpandableView(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({required this.title});

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late ScrollController _controller;
  var _isVisible;
  var count = 1;
  double height = 120;
  List<String> st = ["Test"];
  List<Color> colorList = [Colors.green, Colors.black];

  @override
  initState() {
    super.initState();
    _isVisible = true;
    _controller = new ScrollController();
    _controller.addListener(() {
      if (_controller.position.userScrollDirection == ScrollDirection.forward) {
        if (!_isVisible) {
          setState(() {
            height = 120;
            _isVisible = true;
          });
        }
      }
      if (_controller.position.userScrollDirection == ScrollDirection.reverse) {
        var r = _controller.offset - _controller.offset.floor();
        if (_isVisible) {
          setState(() {
            height = 0;
            _isVisible = false;
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          AnimatedContainer(
            height: height,
            duration: Duration(milliseconds: 200),
            child: AppBar(
              title: Text('Demo'),
            ),
          ),
          Flexible(
            child: SingleChildScrollView(
              controller: _controller,
              child: Column(
                children: <Widget>[
                  ListView.builder(
                      padding: EdgeInsets.all(0),
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: count,
                      itemBuilder: (BuildContext context, int index) {
                        // st.insert(0, randomString(index * 100));
                        return SingleChildScrollView(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                st.insert(count, randomString(index * 100));
                                count = count + 1;
                              });
                            },
                            child: ExpantedView(
                              subtitle: Text("subtitle"),
                              textColor: Colors.black,
                              collapsedIconColor: Colors.white.withAlpha(0),
                              iconColor: Colors.white.withAlpha(0),
                              height: 90,
                              padding: EdgeInsets.only(top: 15, left: 32),
                              index: index,
                              tilePadding: EdgeInsets.only(left: 0),
                              collapsedBackgroundColor: (index % 2 == 0)
                                  ? Colors.yellow
                                  : Colors.white,
                              backgroundColor: (index % 2 == 0)
                                  ? Colors.yellow
                                  : Colors.white,
                              title: Text("$index",
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline6
                                      ?.copyWith(color: Colors.blue)),
                              gestureTapCallback: () {
                                setState(() {
                                  st.insert(count == 0 ? 1 : count, randomString(index == 0 ? 100 : index * 100));
                                  count = count + 1;
                                });
                              },
                              children: <Widget>[
                                Container(
                                  padding: EdgeInsets.only(left: 32, right: 32, bottom: 16),
                                  child: Container(
                                    child: Wrap(
                                      children: <Widget>[
                                        Text(
                                          st[index],
                                          maxLines: null,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return AnimatedContainer(
            duration: Duration(milliseconds: 200),
            height: _isVisible ? 100 : 0,
            child: child,
          );
        },
        child: SingleChildScrollView(
          child: SizedBox(
            height: 120,
            child: BottomNavigationBar(
              backgroundColor: Colors.blue,
              items: [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.child_friendly),
                  label: 'Child',
                ),
              ],
              selectedItemColor: Colors.black,
              unselectedItemColor: Colors.black,
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.removeListener(initState);
  }

  String randomString(int length) {
    const _randomChars =
        "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
    const _charsLength = _randomChars.length;

    final rand = new Random();
    final codeUnits = new List.generate(
      length,
          (index) {
        final n = rand.nextInt(_charsLength);
        return _randomChars.codeUnitAt(n);
      },
    );
    return new String.fromCharCodes(codeUnits);
  }
}
