package com.koralabs.mira

import android.content.Context
import android.content.SharedPreferences
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

import androidx.activity.enableEdgeToEdge
import androidx.core.view.WindowCompat

class MainActivity : FlutterActivity() {
    override fun onCreate(savedInstanceState: android.os.Bundle?) {
        // Aligns the Window to be edge-to-edge
        enableEdgeToEdge()
        WindowCompat.setDecorFitsSystemWindows(window, false)
        super.onCreate(savedInstanceState)
    }
    private val CHANNEL = "com.koralabs.mira/timer_actions"
    private var sharedPrefs: SharedPreferences? = null
    private var methodChannel: MethodChannel? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        
        sharedPrefs = getSharedPreferences("timer_actions", Context.MODE_PRIVATE)
        
        methodChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
        
        // Check for pending actions when app starts
        checkPendingActions()
    }

    override fun onResume() {
        super.onResume()
        checkPendingActions()
    }

    private fun checkPendingActions() {
        val prefs = sharedPrefs ?: return
        val action = prefs.getString("last_action", null)
        
        if (action != null) {
            // Clear the action
            prefs.edit().remove("last_action").apply()
            
            // Send to Flutter
            methodChannel?.invokeMethod("timerAction", action)
        }
    }
}

