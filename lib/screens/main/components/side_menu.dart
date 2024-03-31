import 'package:admin/constants.dart';
import 'package:admin/controllers/LocationProvider.dart';
import 'package:admin/screens/main/components/CustomAnimatedText.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SideMenu extends StatelessWidget {

  const SideMenu({
    Key? key
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    int animationOffset = 200;

    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomAnimatedText(
                  text: "Delta Robot",
                  fontSize: 23,
                  pause: 0
                )
              ],
            ),
          ),
          DrawerListTile(
            title: "Phase Control",
            icon: Icons.rotate_right_outlined,
            location: Location.phase_control,
            pause: animationOffset
          ),
          DrawerListTile(
            title: "Cartesian Control",
            icon: Icons.zoom_out_map,
            location: Location.cartesian_control,
            pause: 2*animationOffset
          ),
          DrawerListTile(
            title: "Learn Path",
            icon: Icons.pan_tool_outlined,
            location: Location.memorize_path,
            pause: 3*animationOffset
          ),
          DrawerListTile(
            title: "Load Path",
            icon: Icons.upload_file,
            location: Location.load_path,
            pause: 4*animationOffset
          ),
          DrawerListTile(
            title: "About",
            icon: Icons.info,
            location: Location.info,
            pause: 4*animationOffset
          ),
        ],
      ),
    );
  }
}

class DrawerListTile extends StatefulWidget {
  const DrawerListTile({
    Key? key,
    required this.title,
    required this.icon,
    required this.pause,
    required this.location,
  }) : super(key: key);

  final int pause;
  final IconData icon;
  final Location location;
  final String title;

  @override
  State<DrawerListTile> createState() => _DrawerListTileState();
}

class _DrawerListTileState extends State<DrawerListTile> {
  @override
  Widget build(BuildContext context) {
    var locationProvider = context.watch<LocationProvider>();
    bool selected = (locationProvider.location == widget.location);

    return ListTile(
      onTap: () => locationProvider.setLocation(widget.location),
      horizontalTitleGap: 0.0,
      leading: Icon(
        widget.icon,
        color: selected? Colors.white: secondaryColor,
        size: 16,
      ),
      tileColor: selected? secondaryColor: Colors.white,
      title: CustomAnimatedText(
        text: widget.title,
        pause: widget.pause
      )
    );
  }
}
