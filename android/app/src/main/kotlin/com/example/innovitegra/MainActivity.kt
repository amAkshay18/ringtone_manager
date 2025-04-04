package com.example.innovitegra

import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import android.media.RingtoneManager
import android.content.Context
import android.media.Ringtone
import android.net.Uri
import android.util.Log
import java.io.File

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.example.ringtone_manager/ringtone"
    private var ringtoneUri: Uri? = null
    private var ringtone: Ringtone? = null

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {

                "getDefaultRingtone" -> {
                    try {
                        ringtoneUri = RingtoneManager.getDefaultUri(RingtoneManager.TYPE_RINGTONE)
                        Log.d("RingtoneDebug", "GetDefault Ringtone URI: ${ringtoneUri.toString()}")

                        if (ringtoneUri == null) {
                            ringtoneUri = RingtoneManager.getDefaultUri(RingtoneManager.TYPE_NOTIFICATION)
                            Log.d("RingtoneDebug", "Fallback Ringtone URI: ${ringtoneUri.toString()}")
                        }

                        if (ringtoneUri != null) {
                            ringtone = RingtoneManager.getRingtone(applicationContext, ringtoneUri)
                            val title = ringtone?.getTitle(applicationContext)

                            val response = hashMapOf<String, Any>()
                            response["title"] = title ?: "Unknown"
                            response["path"] = ringtoneUri.toString()

                            result.success(response)
                        } else {
                            result.error("RINGTONE_URI_NULL", "Ringtone URI is null", null)
                        }
                    } catch (e: Exception) {
                        result.error("RINGTONE_ERROR", "Failed to get ringtone", e.message)
                    }
                }

                "playDefaultRingtone" -> {
                    try {
                        if (ringtoneUri == null) {
                            ringtoneUri = RingtoneManager.getDefaultUri(RingtoneManager.TYPE_RINGTONE)
                            Log.d("RingtoneDebug", "Initial Ringtone URI: ${ringtoneUri.toString()}")

                            if (ringtoneUri == null) {
                                ringtoneUri = RingtoneManager.getDefaultUri(RingtoneManager.TYPE_NOTIFICATION)
                                Log.d("RingtoneDebug", "Fallback Ringtone URI: ${ringtoneUri.toString()}")
                            }
                        }

                        val file = File(ringtoneUri?.path ?: "")
                        if (!file.exists()) {
                            Log.w("RingtoneDebug", "Ringtone file does not exist at: ${file.absolutePath}")
                        }

                        if (ringtoneUri != null) {
                            ringtone = RingtoneManager.getRingtone(applicationContext, ringtoneUri)
                            ringtone?.play()
                            result.success(null)
                        } else {
                            result.error("RINGTONE_URI_NULL", "Ringtone URI is null", null)
                        }
                    } catch (e: Exception) {
                        result.error("PLAY_ERROR", "Failed to play ringtone", e.message)
                    }
                }

                else -> result.notImplemented()
            }
        }
    }
}
