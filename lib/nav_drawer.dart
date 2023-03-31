import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:scouting_app/main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:scouting_app/constants.dart';

class NavDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.home, color: Colors.black,),
            title: Text('Home', style: GoogleFonts.montserrat(fontWeight: FontWeight.bold),),
            onTap: () => {
                Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MyApp()),
              )
            },
          ),
          ListTile(
            leading: Icon(Icons.download, color: Colors.black,),
            title: Text('Import', style: GoogleFonts.montserrat(fontWeight: FontWeight.bold),),
            onTap: () => {
                Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Test1()),
              )
            },
          ),
          ListTile(
            leading: Icon(Icons.upload, color: Colors.black,),
            title: Text('Export', style: GoogleFonts.montserrat(fontWeight: FontWeight.bold),),
            onTap: () => {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ExportPage()),
              ),
            },
          ),
          ]),
      );
  }
}