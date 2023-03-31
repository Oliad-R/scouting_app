import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_tag_editor/tag_editor.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:expandable/expandable.dart';
import 'package:scouting_app/nav_drawer.dart';
import 'package:scouting_app/constants.dart';
import 'package:csv/csv.dart';
import 'package:flutter/services.dart';
// ignore: depend_on_referenced_packages
List savedTags = [];

class Test1 extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _Testing();
}

List<List<dynamic>> _data = [];

class CustomElevatedButton extends StatelessWidget {
  CustomElevatedButton({required this.bID, required this.buttonText, required this.buttonColor, required this.onPress});

  final int bID;
  final void Function()? onPress;
  final String buttonText;
  final Color buttonColor;

  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPress,
      child: Text(
        buttonText,
        style: GoogleFonts.montserrat(fontWeight: FontWeight.bold),
      ),
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white, backgroundColor: buttonColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        fixedSize: bSize,
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({
    required this.label,
    required this.onDeleted,
    required this.index,
  });

  final String label;
  final ValueChanged<int> onDeleted;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Chip(
      labelPadding: const EdgeInsets.only(left: 8.0),
      label: Text(label),
      deleteIcon: Icon(
        Icons.close,
        size: 18,
      ),
      onDeleted: () {
        onDeleted(index);
      },
    );
  }
}

//----------------------------------------------------------------------//
class _Testing extends State<Test1> {
  List tags = [];

  void _loadCSV() async {
    final _rawData = await rootBundle.loadString("assets/my_csv.csv");
    List<List<dynamic>> _listData = const CsvToListConverter().convert(_rawData);
    setState(() {
      _data = _listData;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavDrawer(),
      appBar:
            AppBar(
              shape: RoundedRectangleBorder(
              ),
              elevation: 2,
              title: 
              Center (
                child: Image.asset('assets/images/UMOJA_Icon.png',
                scale: 3.5,),
              ),
              ),
      body: Center(
        child: TagEditor(
          length: savedTags.length,
          delimiters: [',',],
          hasAddButton: true,
          inputDecoration: const InputDecoration(
            border: InputBorder.none,
            hintText: 'Add..',
          ),
          onTagChanged: (newValue) {
            setState(() {
              tags.add(newValue);
              savedTags.add(newValue);
              //change _data value to represent the tag
            });
          },
          tagBuilder: (context, index) => _Chip(
            index: index,
            label: savedTags[index],
            onDeleted: (index) {
              savedTags.removeAt(index);
              tags.removeAt(index);
            },
          ),
        )
        ),
    );
  }
}

void main() {
  runApp(const MyApp());
}

Color UMOJA_Orange = Color.fromARGB(255, 255, 118, 40);
Image Logo = Image.asset('assets/images/UMOJA_Icon.png');

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'UMOJA',
      theme: ThemeData(              
      ),
      home: SplashScreen(
        seconds: 3,
        loaderColor: Colors.white,
        navigateAfterSeconds: MyHomePage(
          title: 'UMOJA'),
        // title: Text(
        //   '',
        //   style: TextStyle(
        //       fontWeight: FontWeight.bold,
        //       fontSize: 40.0,
        //       color: Colors.white),
        // ),
        image: Logo,
        photoSize: 80.0,
        backgroundColor: UMOJA_Orange,
      )
    );
}
}
class MyHomePage extends StatefulWidget {


  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

Size bSize = new Size(90.0, 0.0); // size

class LandingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context){
    final Size size = MediaQuery.of(context).size;
    final double padding = 25;
    return SafeArea(
      child: Scaffold (
        body: SingleChildScrollView(
        child: Container( 
          child: Column(
            children: [
              Wrap(
                alignment: WrapAlignment.end,
                direction: Axis.vertical,
                children: [
                    Container(
                      margin: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 4,
                            offset: Offset(0, 3),
                          )
                        ]
                      ),
                      padding: EdgeInsets.all(10),
                      child: TextButton (
                          onPressed: () { 
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(builder: (context) => MyHomePage()),
                          // );
                          Navigator.of(context).pop();
                      },
                          onHover: (value) {
                            
                          },
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.white,
                        fixedSize: const Size(0.0, 100.0),
                        padding: EdgeInsets.all(0.0)
                      ),
                      child: Icon(Icons.menu, color: Colors.black),
                      )
                    ),
            ]),
              ],
            ),
            ),
          ),
      ),
    );
  }
}

class _MyHomePageState extends State<MyHomePage> {
  void _loadCSV() async {
    final _rawData = await rootBundle.loadString("assets/my_csv.csv");
    List<List<dynamic>> _listData = const CsvToListConverter().convert(_rawData);
    setState(() {
      _data = _listData;
    });
  }

  double vertSpacing = 20.0;
  double leftMargin = 20.0;
  double rightMargin = 20.0;
  double buttonTextSize = 15.0;
  static const int MAX_LENGTH = 9;

  Color getColourState(int j){
    int nullLength = 0;
    for(int i = 0; i < 9; i++) {
      if (_data[j][i] == " null"){
        nullLength++;
      }
    }
    switch (nullLength) {
      case 0:
        return Color.fromARGB(255, 0, 255, 0);
      case MAX_LENGTH-2:
        return Color.fromARGB(255, 255, 0, 0); //RED
      default:
        return UMOJA_Orange;
    }
 }

  // static final List<String> teamNumbers = ["746", "1310", "2198", "2706", "2852", 
  //                                   "2935", "3571", "4308", "4343", "4476", 
  //                                   "5031", "5032", "5036", "5596", "5719", 
  //                                   "6135", "6141", "6397", "6866", "6977", 
  //                                   "6978", "7136", "7558", "7603", "7690", 
  //                                   "7712", "349", "8574", "8729", "8850"];

  @override
  Widget build(BuildContext context) {
    _loadCSV();
    return MaterialApp(
      theme: Theme.of(context).copyWith(
        appBarTheme: Theme.of(context).appBarTheme.copyWith(
          color: UMOJA_Orange,
          titleTextStyle: GoogleFonts.montserrat(),
        ),
      ),
      home: Scaffold(
        drawer: NavDrawer(),
        appBar:
            AppBar(
              shape: RoundedRectangleBorder(
              ),
              elevation: 2,
              title: 
              Center (
                child: Image.asset('assets/images/UMOJA_Icon.png',
                scale: 3.5,),
              ),
              ),
      //--------------------------//
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
        children: [
          Padding(
          padding:EdgeInsets.only(top: vertSpacing, right: rightMargin+10.0, left: leftMargin+35.0),
        child: Text(
          "Scouting",
          textAlign: TextAlign.left,
          style: GoogleFonts.montserratAlternates(
            fontWeight: FontWeight.bold,
            fontSize: 20.0,
            ),
        ),
        ),
      ]),
       Wrap(
        alignment: WrapAlignment.center,
            children: [
            for (var i = 1; i <= 30; i++)
            Padding(
              padding: EdgeInsets.only(top: vertSpacing),
              child: Container(
                  margin: EdgeInsets.only(left: leftMargin, right: rightMargin), //margin
                  child: CustomElevatedButton(bID: i, buttonColor: getColourState(i), buttonText: _data[i][0].toString(),
                    onPress: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Test(PageID: i,)),
                      );
                    }
                  ),
                ),
            ),
      ]),
      ]),
      ),
    );
  }
}

class Test extends StatefulWidget {
  Test({required this.PageID});

  final int PageID;

  @override
  State<StatefulWidget> createState() => Page1(pID: PageID);
}

class MyItem {
  MyItem({
    this.isExpanded: false,
    required this.header,
    required this.body,
  });
  bool isExpanded;
  final Row header;
  final Row body;
}


List<String> categories = [];

class Page1 extends State<Test>{

  Page1({required this.pID});

  int pID;

  // List<MyItem> _items = <MyItem>[
  //   for (int i = 2; i < 9; i++)
  //     MyItem(
  //       header: Text(_data[pID][i].toString(), style: GoogleFonts.montserrat(fontWeight: FontWeight.bold)),
  //       body: Row(
  //         children: [
            
  //         ]),
  //   )];

    @override
    Widget build(BuildContext context) {
      List<MyItem> _items = <MyItem>[
    for (int i = 2; i < 9; i++)
      MyItem(
        header: Row (
          children: [
            Text(_data[0][i].toString(), style: GoogleFonts.montserrat(fontWeight: FontWeight.bold)),
            Text(": "+_data[pID][i].toString(), style: GoogleFonts.montserrat(fontWeight: FontWeight.bold)),
          ]),
        body: Row(
          children: [
            Text(_data[pID][i].toString(), style: GoogleFonts.montserrat(fontWeight: FontWeight.bold)),
            Text(_data[pID][0].toString()+" - "+_data[pID][1], style: GoogleFonts.montserrat(fontWeight: FontWeight.bold),)
          ]),
    )];
    return Scaffold (
    appBar: AppBar(
      title: Text(_data[pID][0].toString()+" - "+_data[pID][1], style: GoogleFonts.montserrat(fontWeight: FontWeight.bold),),
    ),
    body: Padding (
    padding: EdgeInsets.all(20.0),
    child: ListView(
      children: <Widget>[
        ExpansionPanelList(
          expansionCallback: (i, isExpanded) {
            setState(() {
              _items[i].isExpanded = !_items[i].isExpanded;
            });
          },
          children: _items.map((MyItem item) {
            return ExpansionPanel(
              backgroundColor: Colors.white,
              headerBuilder: (context, isExpanded){
                return Padding(
                  padding: EdgeInsets.only(left: 20.0, top: 10.0),
                  child: item.header,
                  );
              }, 
              isExpanded: item.isExpanded,
              body: item.body,
              );
          }).toList(),
        )
      ],
    ),
    ),
    );
  }
}

class ImportPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavDrawer(),
      appBar:
            AppBar(
              shape: RoundedRectangleBorder(
              ),
              elevation: 2,
              title: 
              Center (
                child: Image.asset('assets/images/UMOJA_Icon.png',
                scale: 3.5,),
              ),
              ),
      body: Text("Hello"),
    );
  }
}

class ExportPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}

