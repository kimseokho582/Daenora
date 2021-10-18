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

class PairList<List, String> {
  List date;
  String schdule;
  PairList(this.date, this.schdule);
}

class _MyCalendarState extends State<MyCalendar> {
  CalendarViews _currentView = CalendarViews.dates;
  late int midYear;

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
  List<PairList> _selected = [];
  List<Calendar> _sequentialDates = [];
  List<DateTime> _selectedDate = [];
  late DateTime _currentDateTime, _selectDateTime;
  List<String> _selectedSchdule = [];

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
    _getCalendarSelected();
  }

  void _getCalendarSelected() {
    _sequentialDates.forEach((e) {
      if (e.checkSchedule.schdule != "" && e.thisMonth) {
        _selected.add(PairList(e.checkSchedule.date, e.checkSchedule.schdule));
      }
    });
  }

  Widget build(BuildContext context) {
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
          Container(
            height: 400,
            child: ListView.builder(
              itemCount: _selected.length,
              itemBuilder: (context, index) {
                return Text(
                    "${_selected[index].schdule} ${DateFormat('MM.dd').format(_selected[index].date[0])} ~ ${DateFormat('MM.dd').format(_selected[index].date[_selected[index].date.length - 1])}");
              },
            ),
          ),
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
      onTap: () {
        if (_currentView == CalendarViews.dates) {
          setState(() => {
                (next) ? _getNextMonth() : _getPrevMonth(),
              });
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
    Color _color = Colors.grey;
    if (calendarDate.thisMonth) {
      if (calendarDate.middle) {
        _color = Colors.pink;
      } else if (calendarDate.left) {
        _color = Colors.blue;
      } else if (calendarDate.right) {
        _color = Colors.blue;
      } else if (calendarDate.single) {
        _color = Colors.green;
      }
    }

    return InkWell(
      onTap: () {
        //print(calendarDate.date);
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
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              color: _color,
            ),
            child: Center(
              child: Text(
                '${calendarDate.date.day}',
                style: TextStyle(
                  fontSize: 20,
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
