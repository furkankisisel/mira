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
 * Single Streak Widget
 * Shows a single selected habit's streak
 */
class SingleStreakWidget : GlanceAppWidget() {
    
    override suspend fun provideGlance(context: Context, id: GlanceId) {
        val prefs = context.getSharedPreferences("FlutterSharedPreferences", Context.MODE_PRIVATE)
        
        provideContent {
            SingleStreakContent(prefs)
        }
    }
    
    @Composable
    private fun SingleStreakContent(prefs: SharedPreferences) {
        val isDark = prefs.getString("flutter.theme_is_dark", "false") == "true"
        val primaryColor = prefs.getString("flutter.theme_primary_color", "#5B6B4F") ?: "#5B6B4F"
        
        val habitName = prefs.getString("flutter.single_habit_name", "") ?: ""
        val habitEmoji = prefs.getString("flutter.single_habit_emoji", "📌") ?: "📌"
        val streak = prefs.getString("flutter.single_habit_streak", "0")?.toIntOrNull() ?: 0
        
        val backgroundColor = if (isDark) Color(0xFF1E1E1E) else Color(0xFFFFFFFF)
        val textColor = if (isDark) Color(0xFFE0E0E0) else Color(0xFF1A1A1A)
        val secondaryTextColor = if (isDark) Color(0xFF9E9E9E) else Color(0xFF666666)
        val accentColor = parseColor(primaryColor)
        val fireColor = Color(0xFFFF5722)
        
        Box(
            modifier = GlanceModifier
                .fillMaxSize()
                .background(backgroundColor)
                .cornerRadius(16.dp)
                .padding(16.dp)
                .clickable(actionStartActivity<MainActivity>())
        ) {
            Column(
                modifier = GlanceModifier.fillMaxSize(),
                horizontalAlignment = Alignment.Horizontal.CenterHorizontally,
                verticalAlignment = Alignment.Vertical.CenterVertically
            ) {
                if (habitName.isNotEmpty()) {
                    // Fire + Streak Number
                    Row(
                        horizontalAlignment = Alignment.Horizontal.CenterHorizontally,
                        verticalAlignment = Alignment.Vertical.CenterVertically
                    ) {
                        Text(
                            text = "🔥",
                            style = TextStyle(fontSize = 28.sp)
                        )
                        Spacer(modifier = GlanceModifier.width(4.dp))
                        Text(
                            text = streak.toString(),
                            style = TextStyle(
                                fontSize = 36.sp,
                                fontWeight = FontWeight.Bold,
                                color = ColorProvider(fireColor)
                            )
                        )
                    }
                    
                    Text(
                        text = "gün",
                        style = TextStyle(
                            fontSize = 14.sp,
                            color = ColorProvider(secondaryTextColor)
                        )
                    )
                    
                    Spacer(modifier = GlanceModifier.height(12.dp))
                    
                    // Habit name with emoji
                    Row(
                        horizontalAlignment = Alignment.Horizontal.CenterHorizontally,
                        verticalAlignment = Alignment.Vertical.CenterVertically
                    ) {
                        Text(
                            text = habitEmoji,
                            style = TextStyle(fontSize = 14.sp)
                        )
                        Spacer(modifier = GlanceModifier.width(4.dp))
                        Text(
                            text = habitName,
                            style = TextStyle(
                                fontSize = 12.sp,
                                fontWeight = FontWeight.Medium,
                                color = ColorProvider(textColor)
                            ),
                            maxLines = 1
                        )
                    }
                } else {
                    // No habit selected
                    Text(
                        text = "🔥",
                        style = TextStyle(fontSize = 32.sp)
                    )
                    Spacer(modifier = GlanceModifier.height(8.dp))
                    Text(
                        text = "Alışkanlık seçin",
                        style = TextStyle(
                            fontSize = 12.sp,
                            color = ColorProvider(secondaryTextColor)
                        )
                    )
                    Text(
                        text = "Uygulamada ayarlayın",
                        style = TextStyle(
                            fontSize = 10.sp,
                            color = ColorProvider(accentColor)
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

class SingleStreakWidgetReceiver : GlanceAppWidgetReceiver() {
    override val glanceAppWidget: GlanceAppWidget = SingleStreakWidget()
}
