import 'dart:async';

enum UTCchangeEvent {
  changeUTCup,
  changeUTCdown,
}

class UTCBloc {
  List<String> timezones = [
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

  String pickedUTC;
  int currentUTC = 14;

  final _inputEventController = StreamController<UTCchangeEvent>();
  StreamSink<UTCchangeEvent> get inputEventSink => _inputEventController.sink;

  final _outputStateController = StreamController<String>();
  Stream<String> get outputStateStream => _outputStateController.stream;

  void _mapEventToState(UTCchangeEvent event) {
    if (event == UTCchangeEvent.changeUTCdown &&
        currentUTC > 0 &&
        currentUTC <= timezones.length) {
      currentUTC -= 1;
      pickedUTC = timezones[currentUTC];
      _outputStateController.sink.add(pickedUTC);
    } else if (event == UTCchangeEvent.changeUTCup &&
        currentUTC >= 0 &&
        currentUTC < timezones.length - 1) {
      currentUTC += 1;
      pickedUTC = timezones[currentUTC];
      _outputStateController.sink.add(pickedUTC);
    }
  }

  UTCBloc() {
    _inputEventController.stream.listen(_mapEventToState);
  }

  void dispose() {
    _inputEventController.close();
    _outputStateController.close();
  }
}
