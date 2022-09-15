import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:podcast_app/widgets/music_controls.dart';
import 'package:record/record.dart';

class AudioRecorderScreen extends StatefulWidget {
  const AudioRecorderScreen({Key? key}) : super(key: key);

  @override
  _AudioRecorderScreenState createState() => _AudioRecorderScreenState();
}

class _AudioRecorderScreenState extends State<AudioRecorderScreen> {
  bool isRecording = false;
  bool isRecordCompleted = false;
  int _recordDuration = 0;
  String? path;
  Timer? _timer;
  final _recorder = Record();

  @override
  void initState() {
    isRecording = false;
    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _recorder.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        fit: StackFit.expand,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              isRecording
                  ? Column(
                      children: [
                        RawMaterialButton(
                          onPressed: () {
                            stopRecording();
                          },
                          padding: const EdgeInsets.all(8.0),
                          shape: const CircleBorder(),
                          elevation: 10.0,
                          fillColor: Colors.white,
                          child: const Icon(
                            Icons.stop,
                            color: Colors.red,
                            size: 40,
                          ),
                        ),
                        /*IconButton(
                            onPressed: () {
                              stopRecording();
                            },
                            icon: const Icon(Icons.stop)),*/
                        const SizedBox(
                          height: 10,
                        ),
                        _buildTimer()
                      ],
                    )
                  : RawMaterialButton(
                      onPressed: () {
                        startRecording();
                      },
                      padding: const EdgeInsets.all(8.0),
                      shape: const CircleBorder(),
                      elevation: 10.0,
                      fillColor: Colors.white,
                      child: const Icon(
                        Icons.mic,
                        size: 40,
                      ),
                    ),
              /*IconButton(
                      onPressed: () {
                        startRecording();
                      },
                      icon: const Icon(Icons.mic)),*/
              const SizedBox(
                height: 20,
              ),
              !isRecording && isRecordCompleted
                  ? MusicControls(path: path!)
                  : const SizedBox.shrink()
            ],
          ),
        ],
      ),
    );
  }

  void startRecording() async {
    bool result = await _recorder.hasPermission();

    await _recorder.start();

    bool _isRecording = await _recorder.isRecording();

    setState(() {
      isRecording = _isRecording;
    });

    startTimer();
  }

  void stopRecording() async {
    _timer?.cancel();
    path = await _recorder.stop();
    print('Audio Path :$path');

    setState(() {
      isRecording = false;
      isRecordCompleted = true;
    });
  }



  void startTimer() {
    _recordDuration = 0;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() => _recordDuration++);
    });
  }

  Widget _buildTimer() {
    final String minutes = _formatNumber(_recordDuration ~/ 60);
    final String seconds = _formatNumber(_recordDuration % 60);

    return Text(
      '$minutes : $seconds',
      style: GoogleFonts.slabo27px(color: Colors.red, fontSize: 22),
    );
  }

  String _formatNumber(int number) {
    String numberStr = number.toString();
    if (number < 10) {
      numberStr = '0' + numberStr;
    }

    return numberStr;
  }
}
