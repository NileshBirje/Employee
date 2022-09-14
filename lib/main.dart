// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:employee/EmpPage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'Model/empMaster.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // backgroundColor: Colors.blueGrey,

        applyElevationOverlayColor: true,
        primarySwatch: Colors.blueGrey,
        shadowColor: Colors.blueGrey,
        // brightness: Brightness.light,
      ),
      // darkTheme: ThemeData(
      //   brightness: Brightness.dark,
      //   primarySwatch: Colors.blueGrey,
      // ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    Key? key,
  }) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late var DisplayList = <Employees>[];

  bool showList = true;
  bool network = false;
  var _search = '';

  @override
  void initState() {
    super.initState();
    setState(() {
      _search = '';
      DisplayList = [];
      network = false;
    });
    _checkConnectivityState();
    getEmployeeList();
  }

  //*CHECK CONNECTIVITY OF WIFI OR MOBILE DATA
  Future<void> _checkConnectivityState() async {
    final ConnectivityResult result = await Connectivity().checkConnectivity();
    if (result == ConnectivityResult.wifi ||
        result == ConnectivityResult.mobile) {
      setState(() {
        network = true;
      });
    } else {
      setState(() {
        network = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black54,
        leading: Icon(Icons.menu),
        // ignore: prefer_const_literals_to_create_immutables
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                        title: Center(
                            child: Text(
                          'Instructions',
                          textScaleFactor: 1,
                        )),
                        content: Container(
                          color: Colors.white,
                          height: 170,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              // ignore: prefer_const_literals_to_create_immutables
                              children: [
                                Text(
                                  "Use the search function to find specific Employee",
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  height: 30,
                                ),
                                Text(
                                  "Tap on the card to view their data",
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  height: 30,
                                ),
                                Text(
                                  "Long Press on the card to view their data in a dialog view",
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ));
                  });
            },
            icon: Icon(Icons.help),
          )
        ],
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text("IDZ Digital"),
      ),
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
          child: Container(
            decoration: BoxDecoration(
                // ignore: prefer_const_literals_to_create_immutables
                gradient: LinearGradient(
              colors: [
                Color.fromARGB(246, 39, 79, 105),
                Color.fromARGB(244, 105, 38, 92),
                Color.fromARGB(220, 238, 49, 143),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            )),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                //*SEARCH BAR TO SEARCH LIST
                Stack(
                  children: [
                    Positioned(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.black),
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  onChanged: (value) async {
                                    setState(() {
                                      _search = value;
                                    });
                                  },
                                  keyboardType: TextInputType.text,
                                  textInputAction: TextInputAction.go,
                                  decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      contentPadding:
                                          EdgeInsets.symmetric(horizontal: 15),
                                      hintText: "Search"),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  margin: EdgeInsets.all(10),
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  child: Center(
                    child: Text(
                      "List of Employees",
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                //*MAIN BODY
                Expanded(
                  child: FutureBuilder(
                    future: getEmployeeList(),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.hasData) {
                        if (snapshot.data.length > 0) {
                          return ListView.builder(
                              itemCount: snapshot.data.length,
                              itemBuilder: (context, index) {
                                return InkWell(
                                  onLongPress: (() {
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return Container(
                                              decoration: BoxDecoration(
                                                color: Colors.black45,
                                              ),
                                              child: AlertDialog(
                                                  title: Center(
                                                      child: Text(
                                                    'Employee Details',
                                                    textScaleFactor: 1,
                                                  )),
                                                  content: SizedBox(
                                                    height: 130,
                                                    child: Center(
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        // ignore: prefer_const_literals_to_create_immutables
                                                        children: [
                                                          Text(
                                                            // "Use the search function to find specific data",
                                                            snapshot.data[index]
                                                                    .name +
                                                                ', ' +
                                                                snapshot
                                                                    .data[index]
                                                                    .age
                                                                    .toString(),
                                                            style: TextStyle(
                                                                fontSize: 15,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                          SizedBox(
                                                            height: 20,
                                                          ),
                                                          Text(
                                                            snapshot.data[index]
                                                                .salary
                                                                .toString(),
                                                            style: TextStyle(
                                                                fontSize: 15,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                          SizedBox(
                                                            height: 20,
                                                          ),
                                                          ElevatedButton(
                                                            onPressed:
                                                                () async {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            },
                                                            style: ElevatedButton.styleFrom(
                                                                enableFeedback:
                                                                    true,
                                                                fixedSize: Size(
                                                                    20, 20),
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                primary: Colors
                                                                    .cyan),
                                                            child: Text(
                                                              "OK",
                                                              textScaleFactor:
                                                                  1,
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 15,
                                                                fontFamily:
                                                                    'Inter',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  )));
                                        });
                                  }),
                                  onTap: (() {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: ((context) => EmpPage(
                                                snapshot.data[index]))));
                                  }),
                                  child: Card(
                                    color: Colors.white,
                                    margin: EdgeInsets.only(
                                        top: 10, left: 10, right: 10),
                                    shadowColor: Colors.blueGrey,
                                    elevation: 30,
                                    child: Padding(
                                        padding: EdgeInsets.all(10),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          // ignore: prefer_const_literals_to_create_immutables
                                          children: [
                                            Row(
                                              children: [
                                                Icon(Icons.person),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Text(
                                                    "Name ::",
                                                    style: TextStyle(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                                Text(
                                                  // DisplayList[index].name.toString(),
                                                  snapshot.data[index].name
                                                      .toString(),
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              // ignore: prefer_const_literals_to_create_immutables
                                              children: [
                                                Icon(Icons.numbers_rounded),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Text(
                                                    "Age ::",
                                                    style: TextStyle(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                                Text(
                                                  snapshot.data[index].age
                                                      .toString(),
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              // ignore: prefer_const_literals_to_create_immutables
                                              children: [
                                                Icon(Icons.money_rounded),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Text(
                                                    "Salary ::",
                                                    style: TextStyle(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                                Text(
                                                  snapshot.data[index].salary
                                                      .toString(),
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                          ],
                                        )),
                                  ),
                                );
                              });
                        } else {
                          return const Center(
                            child: Text("Employee does not exist"),
                          );
                        }
                      } else if (snapshot.hasError) {
                        return Text(
                          "Something Went Wrong: ${snapshot.error}",
                          textScaleFactor: 1,
                        );
                      } else {
                        return Center(child: Container());
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  //*FUCNTION TO CALL JSON LINK
  Future getEmployeeList() async {
    try {
      //*STORE DATA AFTER BEING OFFLINE
      SharedPreferences preferences = await SharedPreferences.getInstance();
      dynamic json;
      if (network == true) {
        final res = await http
            .get(Uri.parse("http://aamras.com/dummy/EmployeeDetails.json"));
        preferences.setString('Jsonbody', res.body);
        json = jsonDecode(res.body);
      } else {
        String? jsonData = preferences.getString('Jsonbody');
        json = jsonDecode(jsonData!);
      }
      List<Employees> data = <Employees>[];
      json['employees'].forEach((e) => data.add(Employees.fromJson(e)));

      // DisplayList = <Employees>[];

      // if (data.isNotEmpty) {
      //   setState(() {
      //     DisplayList.addAll(data);
      //   });
      // }

      //*SEARCH FUNCTON HERE
      return _search.isNotEmpty
          ? data
              .where((element) =>
                  element.name!.toLowerCase().contains(_search.toLowerCase()))
              .toList()
          : data;
    } catch (ex) {
      print("Something went wrong");
    }
  }
}



// Container(
          //   height: 80,
          //   width: MediaQuery.of(context).size.width,
          //   decoration: BoxDecoration(
          //     // image: DecorationImage(image: AssetImage("")), //TODO :: add image

          //   ),
          // ),