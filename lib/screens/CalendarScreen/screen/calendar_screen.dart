import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:tiffsy_app/screens/CalendarScreen/bloc/calendar_bloc.dart';
import 'package:tiffsy_app/screens/CalendarScreen/model/calendar_date_model.dart';

class CalendarScreen extends StatefulWidget {
  final String cst_id;
  final String subs_id;
  CalendarScreen({Key? key, required this.cst_id, required this.subs_id})
      : super(key: key);

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  late DateTime _selectedDay;
  late DateTime _focusedDay;
  CalendarFormat _calendarFormat = CalendarFormat.month;

  bool compareDates(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  @override
  void initState() {
    super.initState();
    _focusedDay = DateTime.now();
    _selectedDay = _focusedDay;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CalendarBloc()
        ..add(CalendarInitialFetchEvent(
            cst_id: widget.cst_id, subs_id: widget.subs_id)),
      child: Scaffold(
        appBar: AppBar(title: Text('Scheduled Meals')),
        body: BlocConsumer<CalendarBloc, CalendarState>(
          listener: (context, state) {
            if (state is CalendarErrorState) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.error)),
              );
            } else if (state is OrderCancelSuccessState) {}
          },
          builder: (context, state) {
            if (state is CalendarFetchSuccessState) {
              List<CalendarDataModel> calendarData = state.calendarData;

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
                  focusedDay: DateTime.now(),
                  selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                  calendarBuilders: CalendarBuilders(
                    defaultBuilder: (context, currDate, _) {

                      for (int i = 0; i < calendarData.length; i++) {
                        if (compareDates(
                            DateTime.parse(calendarData[i].dt), currDate)) {
                          if (calendarData[i].bc +
                                  calendarData[i].lc +
                                  calendarData[i].dc ==
                              0) {
                            return Center(
                              child: Container(
                                child: Text(
                                  currDate.day.toString(),
                                  style: TextStyle(color: Colors.white),
                                ),
                                decoration:
                                    BoxDecoration(color: Colors.red[400]),
                              ),
                            );
                          } else {
                            return Center(
                              child: Container(
                                child: ElevatedButton(
                                child: Text(currDate.day.toString()),
                                onPressed: () {
                                  showDialog(
                                      context: context,
                                      builder: ((context) {
                                        bool x = false;
                                        return AlertDialog(
                                          title: Text('Alert'),
                                          content: Container(
                                            height: 200,
                                            width: 40,
                                            child: Column(
                                              children: [
                                                Visibility(
                                                  visible: calendarData[i].bc == 1,
                                                  child: Row(
                                                    children: [
                                                      Text("Breakfast"),
                                                      Switch(
                                                        value:  x,
                                                        onChanged: (value){
                                                        setState(() {
                                                        print(value);
                                                        x = value;
                                                        });
                                                      }
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          actions: [
                                            TextButton(
                                              child: Text("Cancel"),
                                              onPressed: () {},
                                            ),
                                            TextButton(
                                              child: Text("Continue"),
                                              onPressed: () {
                                                 BlocProvider.of<CalendarBloc>(context).add(CancelOrderClicked(cst_id: "1",ordr_id: "1" ));
                                                 // add hoga abhi  
                                              },
                                            )
                                          ],
                                        );
                                      }));
                                },
                              )),
                            );
                          }
                        }
                      }
                      return null; // Default builder for other dates
                    },
                  ),
                ),
              );
            } else if (state is CalendarLoadingState) {
              return Center(child: CircularProgressIndicator());
            } else {
              return Center(child: Text("Error While loading page"));
            }
          },
        ),
      ),
    );
  }
}
