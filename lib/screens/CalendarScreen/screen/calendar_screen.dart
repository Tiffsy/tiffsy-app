import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:tiffsy_app/screens/CalendarScreen/bloc/calendar_bloc.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  late DateTime _selectedDay;
  late DateTime _focusedDay;
  CalendarFormat _calendarFormat = CalendarFormat.month;

  @override
  void initState() {
    super.initState();
    _focusedDay = DateTime.now();
    _selectedDay = _focusedDay;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CalendarBloc()..add(CalendarInitialFetchEvent()),
      child: Scaffold(
        appBar: AppBar(title: Text('Scheduled Meals')),
        body: BlocConsumer<CalendarBloc, CalendarState>(
          listener: (context, state) {
            if(state is CalendarErrorState){
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.error)),
              );
            }
            else if(state is OrderCancelSuccessState){

            }
          },
          builder: (context, state) {
            if(state is CalendarFetchSuccessState){
              return Center(
              child: TableCalendar(
                onFormatChanged: (format) {
                  // This callback is triggered when the displayed calendar format changes.
                  // If you want to disable 2 weeks forward/backward navigation:
                  if (format == CalendarFormat.twoWeeks) {
                    // Set the format to the previous format (e.g., month or week).
                    // This will effectively prevent the 2 weeks format from being displayed.
                    setState(() {
                      _calendarFormat = CalendarFormat
                          .month; // Assuming you have a variable _calendarFormat of type CalendarFormat
                    });
                  }
                },
                
                firstDay: DateTime.now().subtract(Duration(days: 45)),
                lastDay: DateTime.now().add(Duration(days: 45)),
                focusedDay: DateTime.now().subtract(Duration(days: 44)),
                selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                calendarBuilders: CalendarBuilders(
                  defaultBuilder: (context, currDate, _) {
                    List<DateTime> orderDates = state.orderDate;
                    List<DateTime> cancelDates = state.cancelDates;
                    if(cancelDates.any((date) => isSameDay(date, currDate))){
                      if(currDate.compareTo(DateTime.now()) <= 0){ // pervious
                          return Center(
                            child: Container(
                              child: Text(currDate.day.toString(), 
                              style: TextStyle(
                                color: Colors.white
                              ),),
                              decoration: BoxDecoration(
                                color: Colors.red[400]
                              ),
                            ),
                          );
                      }
                      else { // forward
                          return Center(
                            child: Container(
                              child: Text(currDate.day.toString(), 
                              style: TextStyle(
                                color: Colors.white
                              ),),
                              decoration: BoxDecoration(
                                color: Colors.red[200]
                              ),
                            ),
                          );
                      }
                    }
                    else if(orderDates.any((date) => isSameDay(date, currDate))){
                      if(currDate.compareTo(DateTime(2024, 1, 3)) == 0){
                        return ElevatedButton(
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: ((context) {
                                return AlertDialog(
                                  title: Text('Alert'),
                                  content: Text('This is a dialog box.'),
                                );
                              }));
                        },
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.green),
                        ), // Highlighted dates
                        child: Center(
                          child: Text(currDate.day.toString(),
                              style: TextStyle(color: Colors.white)),
                        ),
                      );
                      }
                      else if(currDate.compareTo(DateTime.now()) > 0){ // forward
                        return  ElevatedButton(
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: ((context) {
                                return AlertDialog(
                                  title: Text('Alert'),
                                  content: Text('This is a dialog box.'),
                                );
                              }));
                        },
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.green),
                        ), // Highlighted dates
                        child: Center(
                          child: Text(currDate.day.toString(),
                              style: TextStyle(color: Colors.white)),
                        ),
                      );
                      }
                      else{ // previous
                        return  Center(
                            child: Container(
                              child: Text(currDate.day.toString(), 
                              style: TextStyle(
                                color: Colors.white
                              ),),
                              decoration: BoxDecoration(
                                color: Colors.amber[600]
                              ),
                            ),
                          );
                      }
                    }
                    return null; // Default builder for other dates
                  },
                ),
              ),
            );
            }
            else if(state is CalendarLoadingState){
              return Center(child: CircularProgressIndicator());
            }
            else{
              return Center(child: Text("Error While loading page"));
            }
          },
        ),
      ),
    );
  }
}
