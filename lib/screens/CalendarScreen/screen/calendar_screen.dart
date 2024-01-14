import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:tiffsy_app/screens/CalendarScreen/bloc/calendar_bloc.dart';
import 'package:tiffsy_app/screens/CalendarScreen/model/calendar_date_model.dart';

class CalendarScreen extends StatefulWidget {
  final String cstId;
  final String subsId;
  const CalendarScreen({Key? key, required this.cstId, required this.subsId}) : super(key: key);

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  late DateTime _selectedDay;
  late DateTime _focusedDay;

  bool compareDates(DateTime date1, DateTime date2) {
    return date1.year == date2.year && date1.month == date2.month && date1.day == date2.day;
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
      create: (context) => calendarBloc..add(CalendarInitialFetchEvent(cstId: widget.cstId, subsId: widget.subsId)),
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
              calendarBloc.add(CalendarInitialFetchEvent(cstId: widget.cstId, subsId: widget.subsId));
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
                  Container(
                    width: MediaQuery.sizeOf(context).width - 40,
                    child: TableCalendar(
                      firstDay: DateTime.now().subtract(const Duration(days: 45)),
                      lastDay: DateTime.now().add(const Duration(days: 45)),
                      focusedDay: DateTime.now(),
                      selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                      onDaySelected: (selectedDay, focusedDay) async {
                        if (selectedDay.millisecondsSinceEpoch > DateTime.now().millisecondsSinceEpoch - 86400000) {
                          for (CalendarDataModel element in calendarData) {
                            if (compareDates(selectedDay, DateTime.parse(element.dt.substring(0, 10)))) {
                              await showCancellationSheet(element, calendarBloc);
                            }
                          }
                        }
                      },
                      calendarBuilders: CalendarBuilders(
                        defaultBuilder: (context, day, focusedDay) {
                          for (int i = 0; i < calendarData.length; i++) {
                            CalendarDataModel data = calendarData[i];
                            DateTime dt = DateTime.parse(data.dt.substring(0, 10));
                            if (compareDates(dt, day) &&
                                day.millisecondsSinceEpoch < focusedDay.millisecondsSinceEpoch) {
                              return dateBox(day, true, data.hasNoOrders());
                            } else if (compareDates(dt, day) &&
                                day.millisecondsSinceEpoch > focusedDay.millisecondsSinceEpoch) {
                              return dateBox(day, false, data.hasNoOrders());
                            } else if (compareDates(day, focusedDay)) {}
                          }
                          return null;
                        },
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

  showCancellationSheet(CalendarDataModel calendarData, CalendarBloc calendarBloc) {
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
      {super.key, required this.calendarData, required this.calendarBloc, required this.parentContext});

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
    // TODO: implement initState
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

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.sizeOf(context).width,
      decoration: BoxDecoration(color: const Color(0xffFFFCEF), borderRadius: BorderRadius.circular(36)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          children: [
            const SizedBox(height: 40),
            mealsTakenInitial[0]
                ? Row(
                    children: [
                      const Text(
                        "Breakfast",
                        style: TextStyle(
                          color: Color(0xFF000000),
                          fontSize: 16,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w500,
                          height: 24 / 16,
                          letterSpacing: 0.5,
                        ),
                      ),
                      Spacer(),
                      Checkbox(
                        value: mealsTakenModified[0],
                        onChanged: (newBreakfastValue) {
                          setState(() {
                            mealsTakenModified[0] = false;
                          });
                        },
                      )
                    ],
                  )
                : disabledMealChooser("Breakfast"),
            const Divider(),
            mealsTakenInitial[1]
                ? Row(
                    children: [
                      const Text(
                        "Lunch",
                        style: TextStyle(
                          color: Color(0xFF000000),
                          fontSize: 16,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w500,
                          height: 24 / 16,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const Spacer(),
                      Checkbox(
                        value: mealsTakenModified[1],
                        onChanged: (newBreakfastValue) {
                          setState(() {
                            mealsTakenModified[1] = newBreakfastValue ?? mealsTakenInitial[1];
                          });
                        },
                      )
                    ],
                  )
                : disabledMealChooser("Lunch"),
            const Divider(),
            mealsTakenInitial[2]
                ? Row(
                    children: [
                      const Text(
                        "Dinner",
                        style: TextStyle(
                          color: Color(0xFF000000),
                          fontSize: 16,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w500,
                          height: 24 / 16,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const Spacer(),
                      Checkbox(
                        value: mealsTakenModified[2],
                        onChanged: (newBreakfastValue) {
                          setState(() {
                            mealsTakenModified[2] = newBreakfastValue ?? mealsTakenInitial[2];
                          });
                        },
                      )
                    ],
                  )
                : disabledMealChooser("Dinner"),
            const SizedBox(height: 12),
            confirmCancelButton(
              () {
                //String cst_id = Hive.box("customer_box").get("cst_id");
                widget.calendarBloc.add(CancelButtonClickedEvent(
                  ordr_id: widget.calendarData.ordrId,
                  dt: widget.calendarData.dt,
                  bc: mealsTakenModified[0] ? 1 : 0,
                  lc: mealsTakenModified[1] ? 1 : 0,
                  dc: mealsTakenModified[2] ? 1 : 0,
                ));
                Navigator.pop(context);
              },
            ),
            const SizedBox(height: 12),
            cancelCancelButton(() {
              Navigator.pop(widget.parentContext);
            })
          ],
        ),
      ),
    );
  }
}

Widget disabledMealChooser(String text) {
  return Row(
    children: [
      Text(
        text,
        style: const TextStyle(
          color: Color(0xFFbbbbbb),
          fontSize: 16,
          fontFamily: 'Roboto',
          fontWeight: FontWeight.w300,
          height: 24 / 16,
          letterSpacing: 0.5,
        ),
      ),
      Spacer(),
      Checkbox(
        value: false,
        onChanged: (value) {},
      )
    ],
  );
}

Widget dateBox(
  DateTime date,
  bool isPast,
  bool isCancelled,
) {
  return Center(
    child: Container(
      decoration: ShapeDecoration(
          shape: const CircleBorder(),
          color: isCancelled ? const Color(0xffF84545) : (isPast ? const Color(0xffFFBE1D) : const Color(0xffCBFFB3))),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Text(
          date.day.toString(),
          style: TextStyle(color: isPast ? const Color(0xffffffff) : const Color(0xff121212)),
        ),
      ),
    ),
  );
}

Widget confirmCancelButton(VoidCallback onpress) {
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

Widget cancelCancelButton(VoidCallback onpress) {
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