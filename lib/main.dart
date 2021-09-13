// @dart=2.9
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_midi/flutter_midi.dart';
import 'package:flutter/services.dart';
import 'package:tekartik_midi/midi.dart';
import 'package:tekartik_midi/midi_parser.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final FlutterMidi _flutterMidi = FlutterMidi();

  @override
  void initState() {
    load("assets/sf2/Nice-Steinway-Lite-v3.0.sf2");
    super.initState();
  }

  void load(String asset) async {
    _flutterMidi.unmute(); // Optionally Unmute
    ByteData _byte = await rootBundle.load(asset);
    _flutterMidi.prepare(sf2: _byte);
  }

  void playNote() {
    _flutterMidi.playMidiNote(midi: 60);
  }

  void fixMidi(MidiFile midiFile) {
    if (midiFile == null) return;
    print(midiFile.tracks.first.events.first.toString());
  }

  Future<MidiFile> loadFile() async {
    FilePickerResult result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ["mid", "midi"]);

    Uint8List file;

    if (result != null) {
      file = result.files.first.bytes;
      MidiParser midiParser = MidiParser(file);
      FileParser fileParser = FileParser(midiParser);
      fileParser.parseFile();
      return fileParser.file;
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextButton(
              onPressed: () {
                loadFile();
              },
              child: Text(
                "Load midi"
              ),
            ),
          ],
        ),
      ),
    );
  }
}
