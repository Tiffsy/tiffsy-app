import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:tiffsy_app/screens/CalendarScreen/bloc/calendar_bloc.dart';
import 'package:tiffsy_app/screens/CalendarScreen/model/calendar_date_model.dart';

class CalendarScreen extends StatefulWidget {
  final String cstId;
  final String subsId;
  const CalendarScreen({Key? key, required this.cstId, required this.subsId})
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
    CalendarBloc calendarBloc = CalendarBloc();
    List<CalendarDataModel> calendarData = [];
    return BlocProvider(
      create: (context) => calendarBloc
        ..add(CalendarInitialFetchEvent(
            cstId: widget.cstId, subsId: widget.subsId)),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xfffffcef),
          leadingWidth: 64,
          titleSpacing: 0,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_rounded,
              color: Color(0xff323232),
              size: 24,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: const Text(
            "Order Schedule",
            style: TextStyle(
              fontSize: 20,
              height: 28 / 20,
              fontWeight: FontWeight.w400,
              color: Color(0xff121212),
            ),
          ),
        ),
        body: BlocConsumer<CalendarBloc, CalendarState>(
          listener: (context, state) {
            if (state is CalendarErrorState) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.error)),
              );
            }
          },
          builder: (context, state) {
            if (state is CalendarFetchSuccessState) {
              calendarData = state.calendarData;
              print("___________________");
              print(calendarData.last.toString());
            } else if (state is OrderCancelSuccessState) {
            } else if (state is CalendarLoadingState) {
              return Center(child: CircularProgressIndicator());
            }
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Center(
                child: TableCalendar(
                  calendarFormat: _calendarFormat,
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
                  firstDay: DateTime.now().subtract(const Duration(days: 45)),
                  lastDay: DateTime.now().add(const Duration(days: 45)),
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
                                decoration: const ShapeDecoration(
                                    shape: CircleBorder(),
                                    color: Color(0xffF84545)),
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Text(
                                    currDate.day.toString(),
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            );
                          } else {
                            return Center(
                              child: InkWell(
                                onTap: () {
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
                                                visible:
                                                    calendarData[i].bc == 1,
                                                child: Row(
                                                  children: [
                                                    Text("Breakfast"),
                                                    Switch(
                                                        value: x,
                                                        onChanged: (value) {
                                                          setState(() {
                                                            print(value);
                                                            x = value;
                                                          });
                                                        })
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
                                              BlocProvider.of<CalendarBloc>(
                                                      context)
                                                  .add(CancelOrderClicked(
                                                      cst_id: "1",
                                                      ordr_id: "1"));
                                              // add hoga abhi
                                            },
                                          )
                                        ],
                                      );
                                    }),
                                  );
                                },
                                child: Container(
                                  decoration: ShapeDecoration(
                                      shape: CircleBorder(),
                                      color: Color(0xffFFBE1D)),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Text(currDate.day.toString()),
                                  ),
                                ),
                              ),
                            );
                          }
                        }
                      }
                      return null; // Default builder for other dates
                    },
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
