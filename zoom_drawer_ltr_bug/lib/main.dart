import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'drawer_menu.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MainPageWrapper(),
    );
  }
}

class MainPageWrapper extends StatefulWidget {
  @override
  _MainPageWrapperState createState() => _MainPageWrapperState();
}

class _MainPageWrapperState extends State<MainPageWrapper> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width * 0.80;
    return Listener(
      onPointerDown: (_) {
        final FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus &&
            currentFocus.focusedChild != null) {
          currentFocus.focusedChild?.unfocus();
        }
      },
      child: Scaffold(
        backgroundColor: Colors.grey,
        body: ZoomDrawer(
            style: DrawerStyle.Style6,
            borderRadius: 24.0,
            slideWidth: width,
            openCurve: Curves.fastOutSlowIn,
            closeCurve: Curves.bounceIn,
            //THIS IS WHERE THE BUG IS, CHANGE TO TRUE AND ALL IS FIXED
            isRtl: false,
            menuScreen: DrawerMenu(),
            mainScreen: MyHomePage()),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({
    Key? key,
  }) : super(key: key);
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            IconButton(
                icon: const Icon(Icons.menu, color: Colors.white, size: 40),
                onPressed: () {
                  ZoomDrawer.of(context)!.isOpen()
                      ? ZoomDrawer.of(context)?.close()
                      : ZoomDrawer.of(context)?.open();
                }),
            Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Text('Zoom drawer LTR bug')),
            Spacer()
          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
