import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../Widgets/BasalGraph.dart';
import '../Widgets/BolusGraph.dart';
import '../utils/Colors.dart';

class InsulinScreen extends StatefulWidget {
  const InsulinScreen({super.key});

  @override
  State<InsulinScreen> createState() => _InsulinScreenState();
}

class _InsulinScreenState extends State<InsulinScreen> {
  bool showgraph = false;
  DateTime selectedDate = DateTime.now();
  String formattedstartTime = '';
  Color? activeColor;
  String _selectedText = 'Insulin';
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }



@override
  void dispose() {
    
    // TODO: implement dispose
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onPrimary,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {
            Navigator.pop(context, 'refresh');
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              Container(
                width: width,
                height: height * 0.15,
                color: Theme.of(context).colorScheme.secondary,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Text(
                        "My Diary",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: height * 0.04,
                            fontWeight: AppColor.weight600),
                      ),
                    ),
                    SizedBox(
                      height: height * 0.04,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        selectedBTN('Meal'),
                        selectedBTN('Insulin'),
                        selectedBTN('Sports'),
                      ],
                    )
                  ],
                ),
              ),
              Container(
                height: height * 0.06,
                color: Theme.of(context).colorScheme.primary,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.arrow_back_ios,
                            color: Theme.of(context).colorScheme.tertiary,
                          ),
                          onPressed: () {
                            setState(() {
                              selectedDate =
                                  selectedDate.subtract(Duration(days: 1));
                            });
                          },
                        ),
                        Row(
                          children: [
                            IconButton(
                              icon: Icon(
                                Icons.calendar_month,
                                color: Theme.of(context).colorScheme.tertiary,
                                size: 20,
                              ),
                              onPressed: (){}
                              //  => _selectDate(context),
                            ),
                            SizedBox(width: 5),
                            Text(
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.tertiary,
                              ),
                              DateFormat('dd MMM yyyy').format(selectedDate),
                            ),
                          ],
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.arrow_forward_ios,
                            color: Theme.of(context).colorScheme.tertiary,
                          ),
                          onPressed: () {
                            setState(() {
                              selectedDate =
                                  selectedDate.add(Duration(days: 1));
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: height * 0.03),
              Container(
                child: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Image.asset(
                        'assets/images/drop.png',
                        height: height * 0.09,
                      ),
                      Column(
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.check,
                                color: Colors.green,
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Insulin Pump: Active',
                                style: TextStyle(
                                     color: Theme.of(context).colorScheme.tertiary,
                                    fontSize: height * 0.023,
                                    fontWeight: FontWeight.w500),
                              )
                            ],
                          ),
                          SizedBox(height: 10),
                          Row(
                            children: [
                              Icon(
                                Icons.dock_sharp,
                                size: 30,
                                color: Theme.of(context).colorScheme.tertiary,
                              ),
                              SizedBox(width: 10),
                              Text(
                                '16.9 U',
                                style: TextStyle(
                                     color: Theme.of(context).colorScheme.tertiary,
                                    fontSize: height * 0.021,
                                    fontWeight: FontWeight.w500),
                              ),
                              SizedBox(width: width * 0.001),
                              Text('Total Delivered',
                                  style: TextStyle(
                                       color: Theme.of(context).colorScheme.tertiary,
                                      fontSize: height * 0.020,
                                      fontWeight: FontWeight.w500))
                            ],
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(height: height * 0.01),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          showgraph = false;
                        });
                      },
                      child: Container(
                        height: height * 0.12,
                        width: width * 0.40,
                        decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            border: !showgraph
                                ? Border.all(
                                    color:
                                        Theme.of(context).colorScheme.tertiary,
                                  )
                                : Border.all(
                                    width: 0,
                                    color:
                                        Theme.of(context).colorScheme.primary),
                            borderRadius: BorderRadius.circular(10)),
                        child: Padding(
                          padding: const EdgeInsets.all(9),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Bolus',
                                style: TextStyle(fontSize: height * 0.02,   color: Theme.of(context).colorScheme.tertiary,),
                              ),
                              Text(
                                '7.30 U',
                                style: TextStyle(
                                     color: Theme.of(context).colorScheme.tertiary,
                                    fontSize: height * 0.025,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 3),
                              Text(
                                '43%',
                                style: TextStyle(fontSize: height * 0.015,   color: Theme.of(context).colorScheme.tertiary,),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          showgraph = true;
                        });
                      },
                      child: Container(
                        height: height * 0.12,
                        width: width * 0.40,
                        decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            border: showgraph
                                ? Border.all(
                                    color:
                                        Theme.of(context).colorScheme.tertiary,
                                  )
                                : Border.all(
                                    width: 0,
                                    color:
                                        Theme.of(context).colorScheme.primary),
                            borderRadius: BorderRadius.circular(10)),
                        child: Padding(
                          padding: const EdgeInsets.all(9),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Basal',
                                style: TextStyle(fontSize: height * 0.02,   color: Theme.of(context).colorScheme.tertiary,),
                              ),
                              Text(
                                '9.50 U',
                                style: TextStyle(
                                    fontSize: height * 0.025,
                                    fontWeight: FontWeight.bold,   color: Theme.of(context).colorScheme.tertiary,),
                              ),
                              SizedBox(height: 3),
                              Text(
                                '57%',
                                style: TextStyle(fontSize: height * 0.015,   color: Theme.of(context).colorScheme.tertiary,),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: height * 0.01),
              if (showgraph)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: GestureDetector(onTap: () {}, child: Basalgraph()),
                ),
              if (!showgraph)
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Bolusgraph()),
            ],
          ),
        ),
      ),
    );
  }

  GestureDetector selectedBTN(text) {
    if (_selectedText == text) {
      activeColor = Colors.green;
    } else {
      activeColor = Colors.transparent;
    }
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedText = text;
          print(
              'this is my text $text and this is my selected text $_selectedText');
        });
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: activeColor,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            text,
            style: TextStyle(
                color: Colors.white,
                fontSize: MediaQuery.of(context).size.height * 0.02,
                fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }
}
