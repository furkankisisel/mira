package com.koralabs.mira.widgets

import android.content.Context
import android.content.SharedPreferences
import androidx.compose.runtime.Composable
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.glance.*
import androidx.glance.unit.ColorProvider
import androidx.glance.action.actionStartActivity
import androidx.glance.action.clickable
import androidx.glance.appwidget.GlanceAppWidget
import androidx.glance.appwidget.GlanceAppWidgetReceiver
import androidx.glance.appwidget.provideContent
import androidx.glance.appwidget.cornerRadius
import androidx.glance.layout.*
import androidx.glance.text.FontWeight
import androidx.glance.text.Text
import androidx.glance.text.TextStyle
import com.koralabs.mira.MainActivity

/**
 * Live Rhythm Widget
 * Shows current rhythm window, focus habit, and AI message
 */
class LiveRhythmWidget : GlanceAppWidget() {
    
    override suspend fun provideGlance(context: Context, id: GlanceId) {
        val prefs = context.getSharedPreferences("FlutterSharedPreferences", Context.MODE_PRIVATE)
        
        provideContent {
            LiveRhythmContent(prefs)
        }
    }
    
    @Composable
    private fun LiveRhythmContent(prefs: SharedPreferences) {
        val isDark = prefs.getString("flutter.theme_is_dark", "false") == "true"
        val primaryColor = prefs.getString("flutter.theme_primary_color", "#5B6B4F") ?: "#5B6B4F"
        
        val rhythmWindow = prefs.getString("flutter.rhythm_window", "reflection") ?: "reflection"
        val rhythmEmoji = prefs.getString("flutter.rhythm_emoji", "🌙") ?: "🌙"
        val rhythmWindowName = prefs.getString("flutter.rhythm_window_name", "Yansıma Zamanı") ?: "Yansıma Zamanı"
        val focusHabitName = prefs.getString("flutter.focus_habit_name", "") ?: ""
        val focusHabitEmoji = prefs.getString("flutter.focus_habit_emoji", "📌") ?: "📌"
        val focusProgress = prefs.getString("flutter.focus_habit_progress", "0")?.toIntOrNull() ?: 0
        val focusTarget = prefs.getString("flutter.focus_habit_target", "1")?.toIntOrNull() ?: 1
        val aiMessage = prefs.getString("flutter.focus_habit_ai_message", "") ?: ""
        
        val backgroundColor = if (isDark) Color(0xFF1E1E1E) else Color(0xFFFFFFFF)
        val textColor = if (isDark) Color(0xFFE0E0E0) else Color(0xFF1A1A1A)
        val secondaryTextColor = if (isDark) Color(0xFF9E9E9E) else Color(0xFF666666)
        val accentColor = parseColor(primaryColor)
        
        val progressPercent = if (focusTarget > 0) (focusProgress * 100 / focusTarget) else 0
        
        Box(
            modifier = GlanceModifier
                .fillMaxSize()
                .background(backgroundColor)
                .cornerRadius(16.dp)
                .padding(16.dp)
                .clickable(actionStartActivity<MainActivity>())
        ) {
            Column(
                modifier = GlanceModifier.fillMaxSize()
            ) {
                // Header: Rhythm Window
                Row(
                    modifier = GlanceModifier.fillMaxWidth(),
                    horizontalAlignment = Alignment.Horizontal.Start,
                    verticalAlignment = Alignment.Vertical.CenterVertically
                ) {
                    Text(
                        text = rhythmEmoji,
                        style = TextStyle(fontSize = 24.sp)
                    )
                    Spacer(modifier = GlanceModifier.width(8.dp))
                    Text(
                        text = rhythmWindowName,
                        style = TextStyle(
                            fontSize = 16.sp,
                            fontWeight = FontWeight.Bold,
                            color = ColorProvider(textColor)
                        )
                    )
                }
                
                Spacer(modifier = GlanceModifier.height(12.dp))
                
                // Focus Habit Section
                if (focusHabitName.isNotEmpty()) {
                    Row(
                        modifier = GlanceModifier.fillMaxWidth(),
                        verticalAlignment = Alignment.Vertical.CenterVertically
                    ) {
                        Text(
                            text = focusHabitEmoji,
                            style = TextStyle(fontSize = 18.sp)
                        )
                        Spacer(modifier = GlanceModifier.width(8.dp))
                        Text(
                            text = focusHabitName,
                            style = TextStyle(
                                fontSize = 14.sp,
                                fontWeight = FontWeight.Medium,
                                color = ColorProvider(textColor)
                            )
                        )
                    }
                    
                    Spacer(modifier = GlanceModifier.height(8.dp))
                    
                    // Progress Bar
                    Box(
                        modifier = GlanceModifier
                            .fillMaxWidth()
                            .height(8.dp)
                            .background(Color(0xFFE0E0E0))
                            .cornerRadius(4.dp)
                    ) {
                        Box(
                            modifier = GlanceModifier
                                .fillMaxHeight()
                                .width((progressPercent * 2).dp) // Approximate width
                                .background(accentColor)
                                .cornerRadius(4.dp)
                        ) {}
                    }
                    
                    Spacer(modifier = GlanceModifier.height(4.dp))
                    
                    Text(
                        text = "$progressPercent%",
                        style = TextStyle(
                            fontSize = 12.sp,
                            color = ColorProvider(secondaryTextColor)
                        )
                    )
                    
                    // AI Message
                    if (aiMessage.isNotEmpty()) {
                        Spacer(modifier = GlanceModifier.height(8.dp))
                        Text(
                            text = aiMessage,
                            style = TextStyle(
                                fontSize = 11.sp,
                                color = ColorProvider(secondaryTextColor)
                            ),
                            maxLines = 2
                        )
                    }
                } else {
                    // No focus habit
                    Text(
                        text = "Odak alışkanlığı yok",
                        style = TextStyle(
                            fontSize = 14.sp,
                            color = ColorProvider(secondaryTextColor)
                        )
                    )
                    Spacer(modifier = GlanceModifier.height(4.dp))
                    Text(
                        text = "Bir alışkanlığı odak olarak ayarlayın",
                        style = TextStyle(
                            fontSize = 12.sp,
                            color = ColorProvider(secondaryTextColor)
                        )
                    )
                }
            }
        }
    }
    
    private fun parseColor(hex: String): Color {
        return try {
            val colorInt = android.graphics.Color.parseColor(hex)
            Color(colorInt)
        } catch (e: Exception) {
            Color(0xFF5B6B4F)
        }
    }
}

class LiveRhythmWidgetReceiver : GlanceAppWidgetReceiver() {
    override val glanceAppWidget: GlanceAppWidget = LiveRhythmWidget()
}
