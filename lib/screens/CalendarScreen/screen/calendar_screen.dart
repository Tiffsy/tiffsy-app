import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:tiffsy_app/screens/CalendarScreen/bloc/calendar_bloc.dart';
import 'package:tiffsy_app/screens/CalendarScreen/model/calendar_date_model.dart';
import 'package:fluttertoast/fluttertoast.dart';

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
        backgroundColor: const Color(0xffffffff),
        appBar: AppBar(
          backgroundColor: const Color(0xffffffff),
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
            } else if (state is RefreshCalendarState) {
              calendarBloc.add(CalendarInitialFetchEvent(
                  cstId: widget.cstId, subsId: widget.subsId));
            }
          },
          builder: (context, state) {
            if (state is CalendarFetchSuccessState) {
              calendarData = state.calendarData;
            } else if (state is OrderCancelSuccessState) {
            } else if (state is CalendarLoadingState) {
              return const Center(child: CircularProgressIndicator());
            }
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 12),
                  Container(
                    height: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: const Color(0xfffffcef),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: SizedBox(
                        width: MediaQuery.sizeOf(context).width - 40,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                dateColorKey(Color(0xffFFBE1D),
                                    Color(0xfffdf5d1), "Past Orders"),
                                const Spacer(),
                                dateColorKey(Color(0xff329C00),
                                    Color(0xffCBFFB3), "Upcoming Orders"),
                              ],
                            ),
                            Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                dateColorKey(Color(0xffF84545),
                                    Color(0xffFFDDDD), "Canceled Orders"),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: const Color(0xfffffcef),
                    ),
                    width: MediaQuery.sizeOf(context).width - 30,
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: TableCalendar(
                        availableCalendarFormats: const {
                          CalendarFormat.month: 'Month',
                        },
                        firstDay: DateTime.now().subtract(Duration(days: calendarData.length + 31)),
                        lastDay: DateTime.now().add(Duration(days: calendarData.length + 31)),
                        focusedDay: DateTime.now(),
                        selectedDayPredicate: (day) =>
                            isSameDay(_selectedDay, day),
                        onDaySelected: (selectedDay, focusedDay) async {
                          if (selectedDay.millisecondsSinceEpoch >
                              DateTime.now().millisecondsSinceEpoch -
                                  86400000) {
                            for (CalendarDataModel element in calendarData) {
                              if (compareDates(
                                  selectedDay,
                                  DateTime.parse(
                                      element.dt.substring(0, 10)))) {
                                await showCancellationSheet(
                                    element, calendarBloc);
                              }
                            }
                          }
                        },
                        calendarBuilders: CalendarBuilders(
                          defaultBuilder: (context, day, focusedDay) {
                            for (int i = 0; i < calendarData.length; i++) {
                              CalendarDataModel data = calendarData[i];
                              DateTime dt =
                                  DateTime.parse(data.dt.substring(0, 10));

                              if (compareDates(dt, day) &&
                                  day.millisecondsSinceEpoch <
                                      focusedDay.millisecondsSinceEpoch) {
                                return dateBox(day, true, data.hasNoOrders());
                              } else if (compareDates(dt, day) &&
                                  day.millisecondsSinceEpoch >=
                                      focusedDay.millisecondsSinceEpoch) {
                                return dateBox(day, false, data.hasNoOrders());
                              } else if (compareDates(day, focusedDay)) {}
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  showCancellationSheet(
      CalendarDataModel calendarData, CalendarBloc calendarBloc) {
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return CalendarCancelSheet(
          calendarBloc: calendarBloc,
          calendarData: calendarData,
          parentContext: context,
        );
      },
    );
  }
}

class CalendarCancelSheet extends StatefulWidget {
  const CalendarCancelSheet(
      {super.key,
      required this.calendarData,
      required this.calendarBloc,
      required this.parentContext});

  final CalendarDataModel calendarData;
  final CalendarBloc calendarBloc;
  final BuildContext parentContext;

  @override
  State<CalendarCancelSheet> createState() => _CalendarCancelSheetState();
}

class _CalendarCancelSheetState extends State<CalendarCancelSheet> {
  List<bool> mealsTakenInitial = [];
  List<bool> mealsTakenModified = [];
  @override
  void initState() {
    super.initState();
    mealsTakenInitial = [
      widget.calendarData.bc > 0,
      widget.calendarData.lc > 0,
      widget.calendarData.dc > 0,
    ];
    mealsTakenModified = [
      widget.calendarData.bc > 0,
      widget.calendarData.lc > 0,
      widget.calendarData.dc > 0,
    ];
  }

  Map<String, bool> isPastCancellationDeadline = {
    "breakfast": isPast(DateTime(1970, 1, 1, 7, 0, 0)),
    "lunch": isPast(DateTime(1970, 1, 1, 11, 0, 0)),
    "dinner": isPast(DateTime(1970, 1, 1, 18, 0, 0))
  };

  @override
  Widget build(BuildContext context) {
    bool isToday = compareDates(
        DateTime.parse(widget.calendarData.dt.substring(0, 10)),
        DateTime.now());
    return Container(
      width: MediaQuery.sizeOf(context).width,
      decoration: const BoxDecoration(
          color: Color(0xffFFFCEF),
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(36), topRight: Radius.circular(36))),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 40),
            mealsTakenInitial[0]
                ? (isToday && isPastCancellationDeadline["breakfast"]!
                    ? deadlinePastMealChooser("Breakfast")
                    : Row(
                        children: [
                          const Text(
                            "Breakfast",
                            style: TextStyle(
                              color: Color(0xFF000000),
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              height: 24 / 16,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const Spacer(),
                          Checkbox(
                            value: mealsTakenModified[0],
                            onChanged: (newBreakfastValue) {
                              setState(() {
                                mealsTakenModified[0] = !mealsTakenModified[0];
                              });
                            },
                          )
                        ],
                      ))
                : notInSubscriptionMealChooser("Breakfast"),
            const Divider(),
            mealsTakenInitial[1]
                ? (isToday && isPastCancellationDeadline["lunch"]!
                    ? deadlinePastMealChooser("Lunch")
                    : Row(
                        children: [
                          const Text(
                            "Lunch",
                            style: TextStyle(
                              color: Color(0xFF000000),
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              height: 24 / 16,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const Spacer(),
                          Checkbox(
                            value: mealsTakenModified[1],
                            onChanged: (newLunchValue) {
                              setState(() {
                                mealsTakenModified[1] = !mealsTakenModified[1];
                              });
                            },
                          )
                        ],
                      ))
                : notInSubscriptionMealChooser("Lunch"),
            const Divider(),
            mealsTakenInitial[2]
                ? (isToday && isPastCancellationDeadline["dinner"]!
                    ? deadlinePastMealChooser("Dinner")
                    : Row(
                        children: [
                          const Text(
                            "Dinner",
                            style: TextStyle(
                              color: Color(0xFF000000),
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              height: 24 / 16,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const Spacer(),
                          Checkbox(
                            value: mealsTakenModified[2],
                            onChanged: (newDinnerValue) {
                              setState(() {
                                mealsTakenModified[2] = !mealsTakenModified[2];
                              });
                            },
                          )
                        ],
                      ))
                : notInSubscriptionMealChooser("Dinner"),
            const SizedBox(height: 12),
            confirmCancelationButton(
              () async {
                var alertReturn = await showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        backgroundColor: Color(0xfffffcef),
                        title: Text("Are you sure?"),
                        content:
                            Text("Cancellation requests cannot be undone!"),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, 'Go Back'),
                            child: const Text('Go back'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context, 'Confirm'),
                            child: const Text('Confirm'),
                          ),
                        ],
                      );
                    });

                if (alertReturn == "Confirm") {
                  widget.calendarBloc.add(CancelButtonClickedEvent(
                    sbcr_id: widget.calendarData.sbcrId,
                    ordr_id: widget.calendarData.ordrId,
                    dt: widget.calendarData.dt,
                    bc: mealsTakenModified[0] ? 1 : 0,
                    lc: mealsTakenModified[1] ? 1 : 0,
                    dc: mealsTakenModified[2] ? 1 : 0,
                  ));
                  Navigator.pop(context);
                }
              },
            ),
            const SizedBox(height: 12),
            cancelCancelationButton(() {
              Navigator.pop(widget.parentContext);
            }),
            isToday
                ? const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Text(
                      "*Orders can be cancelled upto 2 hours before delivery!",
                      style: TextStyle(
                          fontSize: 12,
                          color: Color(0xff343434),
                          fontStyle: FontStyle.italic),
                    ),
                  )
                : const SizedBox(),
          ],
        ),
      ),
    );
  }
}

Widget notInSubscriptionMealChooser(String text) {
  return Row(
    children: [
      Text(
        text,
        style: const TextStyle(
          color: Color(0xFFbbbbbb),
          fontSize: 16,
          fontWeight: FontWeight.w200,
          height: 24 / 16,
          letterSpacing: 0.5,
        ),
      ),
      const Spacer(),
      Checkbox(
        value: false,
        onChanged: (value) {},
      )
    ],
  );
}

Widget deadlinePastMealChooser(String text) {
  return Row(
    children: [
      Text(
        text,
        style: const TextStyle(
          color: Color(0xFFaaaaaa),
          fontSize: 16,
          fontWeight: FontWeight.w500,
          height: 24 / 16,
          letterSpacing: 0.5,
        ),
      ),
      const Spacer(),
      Checkbox(
        value: true,
        onChanged: (value) {
          Fluttertoast.showToast(msg: "Deadline for cancellation has passed");
        },
      )
    ],
  );
}

Widget dateBox(DateTime date, bool isPast, bool isCancelled) {
  return Padding(
    padding: const EdgeInsets.all(5),
    child: Center(
      child: Container(
        // height: size,
        // width: size,
        decoration: ShapeDecoration(
            shape: CircleBorder(
                side: BorderSide(
                    width: 1.5,
                    color: isCancelled
                        ? const Color(0xffF84545)
                        : (isPast
                            ? const Color(0xffFFBE1D)
                            : const Color(0xff329C00)))),
            color: isCancelled
                ? const Color(0xffFFDDDD)
                : (isPast ? const Color(0xfffdf5d1) : const Color(0xffCBFFB3))),
        child: Center(
          child: Text(
            date.day.toString(),
            style: TextStyle(color: const Color(0xff121212)),
          ),
        ),
      ),
    ),
  );
}

Widget confirmCancelationButton(VoidCallback onpress) {
  Widget buttonText = const Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Spacer(),
      Text(
        "Confirm",
        style: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 16,
          color: Color(0xff121212),
          height: 24 / 16,
        ),
      ),
      Spacer()
    ],
  );
  return InkWell(
    onTap: () {
      onpress();
    },
    child: Container(
      constraints: const BoxConstraints(maxHeight: 40),
      decoration: BoxDecoration(
        color: const Color(0xffffbe1d),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 10, 24, 10),
        child: buttonText,
      ),
    ),
  );
}

Widget cancelCancelationButton(VoidCallback onpress) {
  return InkWell(
    onTap: () {
      onpress();
    },
    child: Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      clipBehavior: Clip.antiAlias,
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 1, color: Color(0xFFFFBE1D)),
          borderRadius: BorderRadius.circular(6),
        ),
      ),
      child: const Center(
        child: Text(
          "Cancel",
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 16,
            color: Color(0xff121212),
            height: 24 / 16,
          ),
        ),
      ),
    ),
  );
}

bool compareDates(DateTime date1, DateTime date2) {
  return date1.year == date2.year &&
      date1.month == date2.month &&
      date1.day == date2.day;
}

Widget dateColorKey(Color borderColor, Color innerColor, String key) {
  return Row(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Container(
        height: 14,
        width: 14,
        decoration: ShapeDecoration(
            shape: CircleBorder(
              side: BorderSide(width: 1, color: borderColor),
            ),
            color: innerColor),
      ),
      const SizedBox(width: 12),
      Text(
        key,
        style: const TextStyle(
          fontSize: 12,
          height: 20 / 12,
          letterSpacing: 0.5,
          fontWeight: FontWeight.w500,
          color: Color(0xff494949),
        ),
      )
    ],
  );
}

bool isPast(DateTime time) {
  DateTime now = DateTime.now();

  if (now.hour > time.hour) {
    return true;
  } else if (now.hour < time.hour) {
    return false;
  } else {
    if (now.minute > time.minute) {
      return true;
    } else if (now.minute < time.minute) {
      return false;
    } else {
      if (now.second > time.second) {
        return true;
      } else {
        return false;
      }
    }
  }
}
