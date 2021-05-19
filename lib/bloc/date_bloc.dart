import 'dart:async';

enum StartDateEvent {
  eventStart,
  changeUTCup,
  changeUTCdown,
}

class DateBloc {
  DateTime date = DateTime.now();
  int currentUTC = 14;
  List<String> timezonesStr = [
    'UTC-12',
    'UTC-11',
    'UTC-10',
    'UTC-9:30',
    'UTC-9',
    'UTC-8',
    'UTC-7',
    'UTC-6',
    'UTC-5',
    'UTC-4',
    'UTC-3',
    'UTC-2:30',
    'UTC-2',
    'UTC-1',
    'UTC+0',
    'UTC+1',
    'UTC+2',
    'UTC+3',
    'UTC+4',
    'UTC+4:30',
    'UTC+5',
    'UTC+5:30',
    'UTC+5:45',
    'UTC+6',
    'UTC+6:30',
    'UTC+7',
    'UTC+8',
    'UTC+8:45',
    'UTC+9',
    'UTC+9:30',
    'UTC+10',
    'UTC+10:30',
    'UTC+11',
    'UTC+12',
    'UTC+12:45',
    'UTC+13',
    'UTC+14'
  ];
  Map timezones = {
    'UTC-12': {'hours': -12, 'minutes': 0},
    'UTC-11': {'hours': -11, 'minutes': 0},
    'UTC-10': {'hours': -10, 'minutes': 0},
    'UTC-9:30': {'hours': -9, 'minutes': -30},
    'UTC-9': {'hours': -9, 'minutes': 0},
    'UTC-8': {'hours': -8, 'minutes': 0},
    'UTC-7': {'hours': -7, 'minutes': 0},
    'UTC-6': {'hours': -6, 'minutes': 0},
    'UTC-5': {'hours': -5, 'minutes': 0},
    'UTC-4': {'hours': -4, 'minutes': 0},
    'UTC-3': {'hours': -3, 'minutes': 0},
    'UTC-2:30': {'hours': -2, 'minutes': -30},
    'UTC-2': {'hours': -2, 'minutes': 0},
    'UTC-1': {'hours': -1, 'minutes': 0},
    'UTC+0': {'hours': 0, 'minutes': 0},
    'UTC+1': {'hours': 1, 'minutes': 0},
    'UTC+2': {'hours': 2, 'minutes': 0},
    'UTC+3': {'hours': 3, 'minutes': 0},
    'UTC+4': {'hours': 4, 'minutes': 0},
    'UTC+4:30': {'hours': 4, 'minutes': 30},
    'UTC+5': {'hours': 5, 'minutes': 0},
    'UTC+5:30': {'hours': 5, 'minutes': 30},
    'UTC+5:45': {'hours': 5, 'minutes': 45},
    'UTC+6': {'hours': 6, 'minutes': 0},
    'UTC+6:30': {'hours': 6, 'minutes': 30},
    'UTC+7': {'hours': 7, 'minutes': 0},
    'UTC+8': {'hours': 8, 'minutes': 0},
    'UTC+8:45': {'hours': 8, 'minutes': 45},
    'UTC+9': {'hours': 9, 'minutes': 0},
    'UTC+9:30': {'hours': 9, 'minutes': 30},
    'UTC+10': {'hours': 10, 'minutes': 0},
    'UTC+10:30': {'hours': 10, 'minutes': 30},
    'UTC+11': {'hours': 11, 'minutes': 0},
    'UTC+12': {'hours': 12, 'minutes': 0},
    'UTC+12:45': {'hours': 12, 'minutes': 45},
    'UTC+13': {'hours': 13, 'minutes': 0},
    'UTC+14': {'hours': 14, 'minutes': 0},
  };

  final _inputEventController = StreamController<StartDateEvent>();
  StreamSink<StartDateEvent> get inputEventSink => _inputEventController.sink;

  final _outputStateController = StreamController<String>();
  Stream<String> get outputStateStream => _outputStateController.stream;

  void _mapEventToState(StartDateEvent event) {
    if (event == StartDateEvent.eventStart &&
        currentUTC >= 0 &&
        currentUTC < timezonesStr.length) {
      date = DateTime.now();
      _outputStateController.sink
          .add(timeCorrection(date.hour, date.minute, date.second));
    } else if (event == StartDateEvent.changeUTCup &&
        currentUTC >= 0 &&
        currentUTC < timezonesStr.length - 1) {
      currentUTC += 1;
      _outputStateController.sink
          .add(timeCorrection(date.hour, date.minute, date.second));
    } else if (event == StartDateEvent.changeUTCdown &&
        currentUTC > 0 &&
        currentUTC <= timezonesStr.length) {
      currentUTC -= 1;
      _outputStateController.sink
          .add(timeCorrection(date.hour, date.minute, date.second));
    }
  }

  String timeCorrection(int hour, minute, second) {
    int hours = (date.hour + timezones[timezonesStr[currentUTC]]['hours']);
    int minutes = date.minute + timezones[timezonesStr[currentUTC]]['minutes'];
    String correctedHours = '';
    String correctedMinutes = '';
    String seconds = date.second.toString().padLeft(2, '0');
    if (minutes >= 60) {
      hours += 1;
      minutes %= 60;
    } else if (minutes < 0) {
      hours -= 1;
      minutes = 0 + (minutes % 60);
      correctedMinutes = minutes.toString().padLeft(2, '0');
    }
    if (hours >= 24) {
      hours %= 24;
    } else if (hours < 0) {
      hours = 0 + (hours % 24);
    }
    correctedMinutes = minutes.toString().padLeft(2, '0');
    correctedHours = hours.toString().padLeft(2, '0');
    return '$correctedHours:$correctedMinutes:$seconds';
  }

  DateBloc() {
    _inputEventController.stream.listen(_mapEventToState);
  }

  void dispose() {
    _inputEventController.close();
    _outputStateController.close();
  }
}
