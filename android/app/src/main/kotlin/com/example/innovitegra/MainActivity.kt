package com.example.innovitegra

import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import android.media.RingtoneManager
import android.content.Context
import android.media.Ringtone
import android.net.Uri

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.example.ringtone_manager/ringtone"
    private var ringtoneUri: Uri? = null

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "getDefaultRingtone" -> {
                    try {
                        ringtoneUri = RingtoneManager.getDefaultUri(RingtoneManager.TYPE_RINGTONE)
                        val ringtone = RingtoneManager.getRingtone(context, ringtoneUri)
                        val title = ringtone.getTitle(context)
                        
                        val response = hashMapOf<String, Any>()
                        response["title"] = title ?: "Unknown"
                        response["path"] = ringtoneUri.toString()
                        
                        result.success(response)
                    } catch (e: Exception) {
                        result.error("RINGTONE_ERROR", "Failed to get ringtone", e.message)
                    }
                }
                "playDefaultRingtone" -> {
                    try {
                        if (ringtoneUri == null) {
                            ringtoneUri = RingtoneManager.getDefaultUri(RingtoneManager.TYPE_RINGTONE)
                        }
                        
                        val ringtone = RingtoneManager.getRingtone(context, ringtoneUri)
                        ringtone.play()
                        result.success(null)
                    } catch (e: Exception) {
                        result.error("PLAY_ERROR", "Failed to play ringtone", e.message)
                    }
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
    }
}
