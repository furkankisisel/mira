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
import org.json.JSONArray

/**
 * All Streaks Widget
 * Shows a list of all habits with their streaks
 */
class AllStreaksWidget : GlanceAppWidget() {
    
    override suspend fun provideGlance(context: Context, id: GlanceId) {
        val prefs = context.getSharedPreferences("FlutterSharedPreferences", Context.MODE_PRIVATE)
        
        provideContent {
            AllStreaksContent(prefs)
        }
    }
    
    @Composable
    private fun AllStreaksContent(prefs: SharedPreferences) {
        val isDark = prefs.getString("flutter.theme_is_dark", "false") == "true"
        val primaryColor = prefs.getString("flutter.theme_primary_color", "#5B6B4F") ?: "#5B6B4F"
        
        val streaksJson = prefs.getString("flutter.habit_streaks", "[]") ?: "[]"
        val streaks = parseStreaks(streaksJson)
        
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
                modifier = GlanceModifier.fillMaxSize()
            ) {
                // Header
                Row(
                    modifier = GlanceModifier.fillMaxWidth(),
                    verticalAlignment = Alignment.Vertical.CenterVertically
                ) {
                    Text(
                        text = "🔥",
                        style = TextStyle(fontSize = 20.sp)
                    )
                    Spacer(modifier = GlanceModifier.width(8.dp))
                    Text(
                        text = "Streak'lerim",
                        style = TextStyle(
                            fontSize = 16.sp,
                            fontWeight = FontWeight.Bold,
                            color = ColorProvider(textColor)
                        )
                    )
                }
                
                Spacer(modifier = GlanceModifier.height(12.dp))
                
                if (streaks.isNotEmpty()) {
                    // Show up to 5 habits
                    streaks.take(5).forEach { habit ->
                        Row(
                            modifier = GlanceModifier
                                .fillMaxWidth()
                                .padding(vertical = 4.dp),
                            horizontalAlignment = Alignment.Horizontal.Start,
                            verticalAlignment = Alignment.Vertical.CenterVertically
                        ) {
                            Text(
                                text = habit.emoji,
                                style = TextStyle(fontSize = 14.sp)
                            )
                            Spacer(modifier = GlanceModifier.width(8.dp))
                            Text(
                                text = habit.name,
                                style = TextStyle(
                                    fontSize = 13.sp,
                                    color = ColorProvider(textColor)
                                ),
                                modifier = GlanceModifier.defaultWeight()
                            )
                            Text(
                                text = "🔥 ${habit.streak}",
                                style = TextStyle(
                                    fontSize = 13.sp,
                                    fontWeight = FontWeight.Medium,
                                    color = ColorProvider(fireColor)
                                )
                            )
                        }
                    }
                    
                    if (streaks.size > 5) {
                        Spacer(modifier = GlanceModifier.height(4.dp))
                        Text(
                            text = "+${streaks.size - 5} daha",
                            style = TextStyle(
                                fontSize = 11.sp,
                                color = ColorProvider(secondaryTextColor)
                            )
                        )
                    }
                } else {
                    // No streaks
                    Column(
                        modifier = GlanceModifier.fillMaxWidth(),
                        horizontalAlignment = Alignment.Horizontal.CenterHorizontally
                    ) {
                        Text(
                            text = "Henüz streak yok",
                            style = TextStyle(
                                fontSize = 14.sp,
                                color = ColorProvider(secondaryTextColor)
                            )
                        )
                        Spacer(modifier = GlanceModifier.height(4.dp))
                        Text(
                            text = "Alışkanlıklarınızı tamamlayın!",
                            style = TextStyle(
                                fontSize = 12.sp,
                                color = ColorProvider(accentColor)
                            )
                        )
                    }
                }
            }
        }
    }
    
    private data class HabitStreak(
        val id: String,
        val name: String,
        val emoji: String,
        val streak: Int
    )
    
    private fun parseStreaks(json: String): List<HabitStreak> {
        return try {
            val array = JSONArray(json)
            val list = mutableListOf<HabitStreak>()
            for (i in 0 until array.length()) {
                val obj = array.getJSONObject(i)
                list.add(
                    HabitStreak(
                        id = obj.optString("id", ""),
                        name = obj.optString("name", ""),
                        emoji = obj.optString("emoji", "📌"),
                        streak = obj.optInt("streak", 0)
                    )
                )
            }
            list
        } catch (e: Exception) {
            emptyList()
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

class AllStreaksWidgetReceiver : GlanceAppWidgetReceiver() {
    override val glanceAppWidget: GlanceAppWidget = AllStreaksWidget()
}
