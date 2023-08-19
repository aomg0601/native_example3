import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io';  // Platform객체를 사용하기 위해

import 'package:flutter/services.dart';   // 메서드 체널을 이용하기 위해
//import 'package:native_example3/sendDataExample.dart';

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
    return _CupertinoNative();
  }
}

class _CupertinoNative extends State<CupertinoNativeApp> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold();
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
 // String _deviceInfo = 'Unknown info';
  String _deviceInfo = ''; // 나중에 네이티브 정보가 들어올 변수
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
              TextButton(
                  onPressed: (){
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
  // 비동기로 동작하는 _showDialog()함수를 추가
  Future<void> _showDialog() async {
    try {
      await platform3.invokeMethod('showDialog');
    } on PlatformException catch (e) {}
  }

  // 기기정보를 가져오는 _getDeviceInfo()함수
  // 안드로이드와 통신하는 함수여서 상황에 따라 지연이
  // 발생할 수 있으므로 비동기로 선언
  Future<void> _getDeviceInfo() async {
    String batteryLevel;
    try {
      final String result = await platform.invokeMethod('getDeviceInfo');
      batteryLevel = 'Device info : $result';
    } on PlatformException catch (e) {
      batteryLevel = 'Failed to get Device info: ${e.message}.';
    }
    setState((){
      _deviceInfo = batteryLevel;
    });
  }
}