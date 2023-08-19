import 'package:flutter/material.dart';
import 'sendDataExample.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io';  // Platform객체를 사용하기 위해

import 'package:flutter/services.dart';   // 메서드 체널을 이용하기 위해

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      // 운영체제가  IOS면 실행
      return  CupertinoApp(
        debugShowCheckedModeBanner: false,
        home: CupertinoNativeApp(),
      );
    } else {
      // 이외의 운영체제면  실행
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
            primarySwatch: Colors.blue
        ),
        home: NativeApp(),
      );
    }

  }
}

// 앱을 실행한 운영체제가 ios일 때 실행할 클래스
class CupertinoNativeApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _NativeApp();
  }
}
// 앱을 실행한 운영체제가 안드로이드일 때 실행할 클래스
class NativeApp extends StatefulWidget {
  @override
  State<NativeApp> createState() => _NativeApp();
}

class _NativeApp extends State<NativeApp> {
  static const platform = const MethodChannel('com.flutter.dev/info');
  // _deviceInfo는 안드로이드에서 전달받은 기기 정보를 저장하는데 사용
  String _deviceInfo = 'Unknown info';
  //String _deviceInfo = ''; // 나중에 네이티브 정보가 들어올 변수
  static const platform3 = const MethodChannel('com.flutter.dev/dialog');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Native 통신 예제'),
      ),
      body: Container(
        child: Center(
          child: Column(
            children:[
              Text(
              _deviceInfo,
              style: TextStyle(fontSize: 30),
            ),
              TextButton(onPressed: (){
                _showDialog();
                },
                  child: Text('네이티브 창 열기'))
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed:() {
          _getDeviceInfo(); // 안드로이드에서 전달 받은 기기정보를 저장하는데 사용
        },
        child: Icon(Icons.get_app),
      ),
    );
  }
  // 기기정보를 가져오는 _getDeviceInfo()함수
  // 안드로이드와 통신하는 함수여서 상황에 따라 지연이
  // 발생할 수 있으므로 비동기로 선언
  Future<void> _getDeviceInfo() async {
    String deviceInfo;
    try {
      final String result = await platform.invokeMethod('getDeviceInfo');
      deviceInfo = 'Device info : $result';
    } on PlatformException catch (e) {
      deviceInfo = 'Failed to get Device info: ${e.message}.';
    }
    setState((){
      _deviceInfo = deviceInfo;
    });
  }

  // 비동기로 동작하는 _showDialog()함수를 추가
  Future<void> _showDialog() async {
    try {
      await platform3.invokeMethod('showDialog');
    } on PlatformException catch (e) {}
  }

}

class _NativeAppState extends State<NativeApp> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}


class _CupertinoNativeAppState extends State<CupertinoNativeApp> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
