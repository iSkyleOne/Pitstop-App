import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  final bool isClient;

  const AppDrawer({super.key, required this.isClient});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children:
            isClient
                ? _buildClientMenuItems(context)
                : _buildAdminMenuItems(context),
      ),
    );
  }

  List<Widget> _buildClientMenuItems(BuildContext context) {
    return [
      DrawerHeader(
        decoration: BoxDecoration(color: Theme.of(context).primaryColor),
        child: Text('Meniu Client', style: TextStyle(color: Colors.white)),
      ),
      ListTile(
        leading: Icon(Icons.dashboard),
        title: Text('Dashboard'),
        onTap: () => Navigator.pushNamed(context, '/client/dashboard'),
      ),
      ListTile(
        leading: Icon(Icons.person),
        title: Text('Profil'),
        onTap: () => Navigator.pushNamed(context, '/client/profile'),
      ),
      ListTile(
        leading: Icon(Icons.directions_car),
        title: Text('Mașinile mele'),
        onTap: () => Navigator.pushNamed(context, '/client/cars'),
      ),
      ListTile(
        leading: Icon(Icons.calendar_today),
        title: Text('Programările mele'),
        onTap: () => Navigator.pushNamed(context, '/client/appointments'),
      ),
    ];
  }

  List<Widget> _buildAdminMenuItems(BuildContext context) {
    return [
      DrawerHeader(
        decoration: BoxDecoration(color: Theme.of(context).primaryColor),
        child: Text('Meniu Admin', style: TextStyle(color: Colors.white)),
      ),
      ListTile(
        leading: Icon(Icons.dashboard),
        title: Text('Dashboard'),
        onTap: () => Navigator.pushNamed(context, '/admin/dashboard'),
      ),
      ListTile(
        leading: Icon(Icons.calendar_today),
        title: Text('Programări'),
        onTap: () => Navigator.pushNamed(context, '/admin/appointments'),
      ),
      ListTile(
        leading: Icon(Icons.people),
        title: Text('Clienți'),
        onTap: () => Navigator.pushNamed(context, '/admin/customers'),
      ),
      ListTile(
        leading: Icon(Icons.build),
        title: Text('Servicii'),
        onTap: () => Navigator.pushNamed(context, '/admin/services'),
      ),
    ];
  }
}
