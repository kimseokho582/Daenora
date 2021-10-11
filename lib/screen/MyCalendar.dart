import 'package:deanora/Widgets/MakeCalendar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MyCalendar extends StatefulWidget {
  const MyCalendar({Key? key}) : super(key: key);

  @override
  _MyCalendarState createState() => _MyCalendarState();
}

class Pair<T1, Datetime> {
  final T1 _schduleString;
  final Datetime _schduleDate;
  Pair(this._schduleString, this._schduleDate);
}

class _MyCalendarState extends State<MyCalendar> {
  CalendarViews _currentView = CalendarViews.dates;
  late int midYear;
  final _addSchedule = TextEditingController();
  List<Pair> _schedule = [];
  final List<String> _weekDays = [
    'SUN',
    "MON",
    'TUE',
    'WED',
    'THU',
    'FRI',
    'SAT'
  ];
  final List<String> _monthNames = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];
  List<Calendar> _sequentialDates = [];
  late DateTime _currentDateTime, _selectDateTime;
  String _scheduleInput = "", _schduleFrom = "", _schduleUntill = "";

  @override
  void initState() {
    super.initState();
    final date = DateTime.now();
    _currentDateTime = DateTime(date.year, date.month);
    _selectDateTime = DateTime(date.year, date.month, date.day);
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      setState(() => _getCalendar());
    });
  }

  void _getCalendar() {
    _sequentialDates = CustomCalendar().getMonthCalendar(
        _currentDateTime.month, _currentDateTime.year,
        startWeekDay: StartWeekDay.sunday);
  }

  Widget build(BuildContext context) {
    //print(_currentDateTime);
    //print(_selectDateTime);
    //calendar.map((e) => print(e.date)).toList();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.all(20),
            height: MediaQuery.of(context).size.height * 0.5,
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(20),
            ),
            child: _dateView(),
          ),
          ElevatedButton(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                        title: Text("일정"),
                        content: Column(
                          children: [
                            SizedBox(
                              height: 100,
                              child: CupertinoDatePicker(
                                initialDateTime: DateFormat('yyyy-MM-dd')
                                    .parse('2021-09-01'),
                                mode: CupertinoDatePickerMode.date,
                                onDateTimeChanged: (dateTime) {
                                  _schduleFrom = DateFormat('yyyy-MM-dd')
                                      .format(dateTime)
                                      .toString();
                                },
                              ),
                            ),
                            SizedBox(
                              height: 50,
                            ),
                            SizedBox(
                              height: 100,
                              child: CupertinoDatePicker(
                                initialDateTime: DateFormat('yyyy-MM-dd')
                                    .parse('2021-09-01'),
                                mode: CupertinoDatePickerMode.date,
                                onDateTimeChanged: (dateTime) {
                                  _schduleUntill = DateFormat('yyyy-MM-dd')
                                      .format(dateTime)
                                      .toString();
                                },
                              ),
                            ),
                            TextField(
                              onChanged: (String value) {
                                _scheduleInput = value;
                              },
                            ),
                          ],
                        ),
                        actions: [
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _schedule.add(Pair(_scheduleInput,
                                    _schduleFrom + "/" + _schduleUntill));
                              });
                            },
                            child: Text("Add"),
                          )
                        ]);
                  });
            },
            child: Icon(Icons.add),
          ),
          TextField(
            controller: _addSchedule,
          ),
          Center(
            child: Container(
              height: 200,
              child: ListView.builder(
                itemCount: _schedule.length,
                itemBuilder: (BuildContext context, int index) {
                  return Dismissible(
                      key: Key(_schedule[index]._schduleString),
                      child: Card(
                          child: ListTile(
                        title: Column(
                          children: [
                            Text(_schedule[index]._schduleString),
                            Text(_schedule[index]._schduleDate),
                          ],
                        ),
                      )));
                },
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _dateView() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        SizedBox(
          height: 10,
        ),
        Row(children: [
          _toggleBtn(false),
          Expanded(
              child: InkWell(
            onTap: () {
              setState(() {
                // explained in later stages
                _currentView = CalendarViews.months;
              });
            },
            child: Center(
              child: Text(
                '${_monthNames[_currentDateTime.month - 1]}  ${_currentDateTime.year}',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700),
              ),
            ),
          )),
          _toggleBtn(true),
        ]),
        Flexible(child: _calendarBody()),
      ],
    );
  }

  Widget _toggleBtn(bool next) {
    return InkWell(
      // explained in later stages
      onTap: () {
        if (_currentView == CalendarViews.dates) {
          setState(() => (next) ? _getNextMonth() : _getPrevMonth());
        } else if (_currentView == CalendarViews.year) {
          if (next) {
            midYear =
                (midYear == null) ? _currentDateTime.year + 9 : midYear + 9;
          } else {
            midYear =
                (midYear == null) ? _currentDateTime.year - 9 : midYear - 9;
          }
          setState(() {});
        }
      },
      child: Container(
        width: 50,
        height: 50,
        child: Icon(
          (next) ? Icons.arrow_forward_ios : Icons.arrow_back_ios,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _calendarBody() {
    if (_sequentialDates == null) return Text("Calendar Error");
    return GridView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      itemCount: _sequentialDates.length + 7, //dates+weekday
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        childAspectRatio: MediaQuery.of(context).size.width /
            (MediaQuery.of(context).size.height / 2.2),
        crossAxisCount: 7,
        mainAxisSpacing: 0,
        crossAxisSpacing: 0,
      ),
      itemBuilder: (context, index) {
        if (index < 7) return _weekDayTitle(index);
        return _calendarDates(_sequentialDates[index - 7]);
      },
    );
  }

  Widget _weekDayTitle(int index) {
    return Container(
      color: Colors.blue,
      padding: EdgeInsets.zero,
      child: Center(
        child: Text(
          _weekDays[index],
          style: TextStyle(color: Colors.yellow, fontSize: 12),
        ),
      ),
    );
  }

  void _getNextMonth() {
    if (_currentDateTime.month == 12) {
      _currentDateTime = DateTime(_currentDateTime.year + 1, 1);
    } else {
      _currentDateTime =
          DateTime(_currentDateTime.year, _currentDateTime.month + 1);
    }
    _getCalendar();
  }

// get previous month calendar
  void _getPrevMonth() {
    if (_currentDateTime.month == 1) {
      _currentDateTime = DateTime(_currentDateTime.year - 1, 12);
    } else {
      _currentDateTime =
          DateTime(_currentDateTime.year, _currentDateTime.month - 1);
    }
    _getCalendar();
  }

  Widget _calendarDates(Calendar calendarDate) {
    return InkWell(
      onTap: () {
        print(calendarDate.date);
        if (_selectDateTime != calendarDate.date) {
          if (calendarDate.nextMonth) {
            _getNextMonth();
          } else if (calendarDate.prevMonth) {
            _getPrevMonth();
          }
          setState(() => _selectDateTime = calendarDate.date);
        }
      },
      child: Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(100)),
        child: Center(
          child: Container(
            height: 25,
            width: 25,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100), color: Colors.blue),
            child: Center(
              child: Text(
                '${calendarDate.date.day}',
                style: TextStyle(
                  color: (calendarDate.thisMonth)
                      ? (calendarDate.date.weekday == DateTime.sunday)
                          ? Colors.yellow
                          : Colors.white
                      : (calendarDate.date.weekday == DateTime.sunday)
                          ? Colors.yellow.withOpacity(0.5)
                          : Colors.white.withOpacity(0.5),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

enum CalendarViews { dates, months, year }
