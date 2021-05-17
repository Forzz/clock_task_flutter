import 'dart:async';

import 'package:clock_task/bloc/UTC_bloc.dart';
import 'package:clock_task/bloc/date_bloc.dart';
import 'package:flutter/material.dart';

class ClockScreen extends StatefulWidget {
  @override
  _ClockScreenState createState() => _ClockScreenState();
}

class _ClockScreenState extends State<ClockScreen> {
  DateBloc _bloc = DateBloc();
  UTCBloc _utcBloc = UTCBloc();

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    Timer.periodic(Duration(seconds: 1),
        (Timer T) => _bloc.inputEventSink.add(StartDateEvent.eventStart));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            StreamBuilder<Object>(
                stream: _bloc.outputStateStream,
                initialData: DateTime.now().toString(),
                builder: (context, snapshot) {
                  return Flexible(
                    child: Text(
                      snapshot.data,
                      style: TextStyle(
                        fontSize: 75,
                        fontFamily: 'Jost',
                      ),
                    ),
                  );
                }),
            Flexible(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: GestureDetector(
                      child: Container(
                        child: Text(
                          '−',
                          style: TextStyle(
                            fontSize: 50,
                            fontFamily: 'Jost',
                          ),
                        ),
                      ),
                      onTap: () {
                        _bloc.inputEventSink.add(StartDateEvent.changeUTCdown);
                        _utcBloc.inputEventSink
                            .add(UTCchangeEvent.changeUTCdown);
                      },
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  StreamBuilder<Object>(
                      stream: _utcBloc.outputStateStream,
                      initialData: 'UTC+0',
                      builder: (context, snapshot) {
                        return Container(
                          alignment: Alignment.center,
                          height: 40,
                          width: 150,
                          child: Text(
                            snapshot.data,
                            style: TextStyle(
                              fontSize: 30,
                              fontFamily: 'Jost',
                            ),
                          ),
                        );
                      }),
                  SizedBox(
                    width: 20,
                  ),
                  Flexible(
                    child: GestureDetector(
                      child: Container(
                        child: Text(
                          '+',
                          style: TextStyle(
                            fontSize: 50,
                            fontFamily: 'Jost',
                          ),
                        ),
                      ),
                      onTap: () {
                        _bloc.inputEventSink.add(StartDateEvent.changeUTCup);
                        _utcBloc.inputEventSink.add(UTCchangeEvent.changeUTCup);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
