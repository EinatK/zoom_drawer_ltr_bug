import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';

class DrawerMenu extends StatefulWidget {
  @override
  _DrawerMenuState createState() => _DrawerMenuState();
}

class _DrawerMenuState extends State<DrawerMenu>
    with AutomaticKeepAliveClientMixin {
  final _textFieldController = TextEditingController();
  @override
  bool get wantKeepAlive => true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    ZoomDrawer.of(context)?.stateNotifier?.addListener(() {
      if (ZoomDrawer.of(context)?.stateNotifier?.value == DrawerState.closing) {
        _textFieldController.clear();
      }
    });
  }

  @override
  void dispose() {
    ZoomDrawer.of(context)?.dispose();
    _textFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final menuController = ZoomDrawer.of(context);

    return Container(
      decoration: const BoxDecoration(
          gradient: LinearGradient(
        colors: [Colors.blueGrey, Colors.blue],
        begin: Alignment.topRight,
        end: Alignment.topLeft,
      )),
      child: GestureDetector(
        onTap: () => menuController?.close(),
        child: Container(
          margin:
              EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.2),
          child: SafeArea(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                _searchBar(),
                Expanded(child: _buildMenu()),
              ])),
        ),
      ),
    );
  }

  Widget _searchBar() => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: TextField(
            controller: _textFieldController,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.all(0),
              enabledBorder: _border(),
              focusedBorder: _border(),
              border: _border(),
              prefixIcon: const Icon(
                Icons.search,
                color: Colors.white,
              ),
            ),
            cursorColor: Colors.white),
      );

  OutlineInputBorder _border() => OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.grey, width: 1),
      borderRadius: BorderRadius.circular(25));

  ListView _buildMenu() {
    return ListView.builder(
        addAutomaticKeepAlives: true,
        shrinkWrap: true,
        itemCount: apps.length,
        itemBuilder: (context, index) {
          final keys = apps.keys.toList();
          final String curKey = keys[index];
          final folderItems = apps[keys[index]];

          return Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              if (curKey.isNotEmpty)
                _sectionHeader(
                  title: curKey,
                ),
              const SizedBox(
                height: 10,
              ),
              ..._menuItems(items: folderItems!)
            ],
          );
        });
  }

  List<Widget> _menuItems({
    required List<App> items,
  }) =>
      items.map((element) {
        return _itemTile(
          app: element,
        );
      }).toList();

  ListTile _sectionHeader({
    required String title,
  }) {
    return ListTile(
      // tileColor: backgroundColor,
      visualDensity: VisualDensity.compact,
      dense: true,
      title: Text(
        title,
      ),
    );
  }

  Widget _itemTile({
    required App app,
  }) {
    return Builder(
      builder: (BuildContext context) => InkWell(
        onTap: () {
          ZoomDrawer.of(context)?.close();
        },
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                  tileColor: Colors.transparent,
                  visualDensity:
                      const VisualDensity(horizontal: 0, vertical: -4),
                  title: Text(
                    app.name,
                  ),
                  leading: Icon(app.icon, color: Colors.white, size: 30)),
            ),
          ],
        ),
      ),
    );
  }
}

class App {
  final IconData icon;
  final String name;

  const App({
    required this.name,
    required this.icon,
  });
}

const Map<String, List<App>> apps = {
  'Work': workApps,
  'Social': socialApps,
  'Commerce': consumerApps
};

const List<App> workApps = [
  App(
    icon: Icons.schedule,
    name: 'Calendar',
  ),
  App(
    icon: Icons.message_outlined,
    name: 'Messages',
  ),
  App(
    icon: Icons.description_outlined,
    name: 'Procedures',
  ),
  App(
    icon: Icons.perm_phone_msg_outlined,
    name: 'Contact',
  ),
  App(
    name: 'Salaries',
    icon: Icons.attach_money,
  ),
  App(
    icon: Icons.contacts_outlined,
    name: 'Phone Book',
  ),
  App(icon: Icons.list_alt, name: 'Forms'),
  App(
    name: 'Convalescence fees',
    icon: Icons.monetization_on,
  ),
  App(
    name: 'Employee Seminars',
    icon: Icons.local_library_outlined,
  ),
  App(
    icon: Icons.info_outline,
    name: 'About',
  ),
  App(
    name: 'Security',
    icon: Icons.lock_outline,
  ),
];

const List<App> socialApps = [
  App(
    icon: Icons.ballot_outlined,
    name: 'Polls',
  ),
  App(
    icon: Icons.forum_outlined,
    name: 'Chat',
  ),
  App(
    icon: Icons.photo_library_outlined,
    name: 'Gallery',
  ),
  App(name: 'Events', icon: Icons.event_outlined),
];

const List<App> consumerApps = [
  App(
    icon: Icons.restaurant_menu_outlined,
    name: 'Food',
  ),
  App(
    icon: Icons.redeem,
    name: 'Benefits',
  ),
  App(
    name: '2nd Hand',
    icon: Icons.shopping_cart_outlined,
  ),
  App(
    name: 'Quick Groceries',
    icon: Icons.local_grocery_store_outlined,
  ),
];
