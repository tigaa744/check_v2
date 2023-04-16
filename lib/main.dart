import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MDM Checker',
      home: Scaffold(
        appBar: AppBar(
          title: Text('MDM Checker'),
        ),
        body: Center(
          child: MdmStatus(),
        ),
      ),
    );
  }
}

class MdmStatus extends StatefulWidget {
  @override
  _MdmStatusState createState() => _MdmStatusState();
}

class _MdmStatusState extends State<MdmStatus> {
  Future<bool> _hasMdm = Future.value(false);

  Future<bool> hasMdm() async {
    if (Platform.isMacOS) {
      try {
        final csrutilOutput = await Process.run('csrutil', ['status']);
        //  Process.runSync('profiles', ['status', '-type', 'enrollment']);
        // return result.stdout.toString().contains('MDM');
        return csrutilOutput.stdout.toString().contains('MDM');
      } on PlatformException catch (_) {
        // Handle error.
        return false;
      }
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _hasMdm,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                (snapshot.data ?? false)
                    ? 'This device has MDM installed.'
                    : 'This device does not have MDM installed.',
                style: TextStyle(fontSize: 20),
              ),

              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _hasMdm = hasMdm();
                  });
                },
                child: Text('Check MDM Status'),
              ),
            ],
          );
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }
}
