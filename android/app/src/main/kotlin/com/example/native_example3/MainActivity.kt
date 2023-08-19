package com.example.native_example3

import android.os.Build
import androidx.annotation.NonNull;
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

import android.app.AlertDialog
import io.flutter.embedding.android.FlutterActivity
import android.util.Base64 //Base64 인코딩을 사용하기 위한 라이브러리
import io.flutter.plugins.GeneratedPluginRegistrant
import java.lang.reflect.Method

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.flutter.dev/info"
    private val CHANNEL2 = "com.flutter.dev/encrypto" // 플러터 프로젝트에 작성한 메서ㄷ 체널의 키 값과 일치
    private val CHANNEL3 = "com.flutter.dev/dialog"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine);

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger,
                CHANNEL2).setMethodCallHandler{ call, result ->
            if (call.method=="getEncrypto"){
                val data = call.arguments.toString().toByteArray();
                val changeText = Base64.encodeToString(data,Base64.DEFAULT)
                result.success(changeText)
            }
            // 'getDecode'호출에 대응하는 코드를 추가
            else if (call.method=="getDecode"){
                //
                val changedText = Base64.decode(call.arguments.toString(),Base64.DEFAULT)
                result.success(String(changedText))
            }
        }
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger,CHANNEL3)
                .setMethodCallHandler { call, result ->
                    if (call.method == "showDialog") {
                        AlertDialog.Builder(this)
                                .setTitle("Flutter").setMessage("네이티브에서 출력하는 창입니다")
                                .show()
                    }
                }
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger,CHANNEL3)
                .setMethodCallHandler { call, result ->
                    if (call.method == "showDialog") {
                        // 안드로이드 알림 창을 띄우기
                        AlertDialog.Builder(this)
                                .setTitle("Flutter")
                                .setMessage("네이티브에서 출력하는 창입니다")
                                .show()
                    }

        }
    }
    private  fun getDeviceInfo() : String {
        val sb = StringBuffer()
        sb.append(Build.DEVICE+"\n") // import 필요
        sb.append(Build.BRAND+"\n")
        sb.append(Build.MODEL+"\n")
        return sb.toString()
    }
}