// ignore_for_file: prefer_const_constructors

import 'package:employee/Model/empMaster.dart';
import 'package:flutter/material.dart';


Employees? employees;

class EmpPage extends StatefulWidget {
  EmpPage(_employees, {Key? key}) : super(key: key) {
    employees = _employees;
  }

  @override
  State<EmpPage> createState() => _EmpPageState();
}

class _EmpPageState extends State<EmpPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          appBar: AppBar(title: Text(employees!.name.toString())),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
        gradient: LinearGradient(
          // ignore: prefer_const_literals_to_create_immutables
          colors: [
        Color.fromARGB(220, 238, 49, 143),
        Color.fromARGB(246, 39, 79, 105),
        Color.fromARGB(244, 105, 38, 92),
        Color.fromARGB(255, 255, 255, 255)
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        )),

        // child: Center(
        //   child: Text("Welcome ${employees!.name.toString().toUpperCase()},\n Your Monthly Salary is ${employees!.salary.toString()}", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, ),
        child: SizedBox(
          height: 100,
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                    flex: 2,
                    child: Container(
                      width: 100,
                      height: 200,
                      // color: Colors.red,
                      decoration: BoxDecoration(
                        color: Colors.white30,
                        border: Border(
                          left: BorderSide(width: 2),
                          bottom: BorderSide(width: 2),
                          top: BorderSide(width: 2)
                        ),
                        image: DecorationImage(
                          
                          image: AssetImage("assets/user.png"),
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                    )),
                Expanded(
                    flex: 4,
                    child: Container(
                      width: 30,
                      height: 200,
                      decoration: BoxDecoration(
                        // border: Border(left: BorderSide(color: Colors.black, width: 2)),
                        border: Border.all(width: 2),
                        color: Colors.white30
                        
                      ),
                      // color: Colors.yellow,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 50.0),
                            child: Text(
                              "Name :: ${employees!.name.toString().toUpperCase()}",
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold,),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 50.0),
                            child: Text(
                              "Age :: ${employees!.age.toString()}",
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold, ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 50.0),
                            child: Text(
                              "Salary :: ${employees!.salary.toString()}",
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold, ),
                            ),
                          ),
                        ],
                      ),
                    )),
              ],
            ),
          ),
        ),
      ),
    ));
  }
}

//*employees!.name.toString()
