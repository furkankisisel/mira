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
 * Mood Widget
 * Shows today's mood entry with emoji and label
 */
class MoodWidget : GlanceAppWidget() {
    
    override suspend fun provideGlance(context: Context, id: GlanceId) {
        val prefs = context.getSharedPreferences("FlutterSharedPreferences", Context.MODE_PRIVATE)
        
        provideContent {
            MoodContent(prefs)
        }
    }
    
    @Composable
    private fun MoodContent(prefs: SharedPreferences) {
        val isDark = prefs.getString("flutter.theme_is_dark", "false") == "true"
        val primaryColor = prefs.getString("flutter.theme_primary_color", "#5B6B4F") ?: "#5B6B4F"
        
        val hasEntry = prefs.getString("flutter.mood_has_entry", "false") == "true"
        val moodEmoji = prefs.getString("flutter.mood_emoji", "❓") ?: "❓"
        val moodLabel = prefs.getString("flutter.mood_label", "Henüz kayıt yok") ?: "Henüz kayıt yok"
        val moodNote = prefs.getString("flutter.mood_note", "") ?: ""
        
        val backgroundColor = if (isDark) Color(0xFF1E1E1E) else Color(0xFFFFFFFF)
        val textColor = if (isDark) Color(0xFFE0E0E0) else Color(0xFF1A1A1A)
        val secondaryTextColor = if (isDark) Color(0xFF9E9E9E) else Color(0xFF666666)
        val accentColor = parseColor(primaryColor)
        
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
                // Large Emoji
                Text(
                    text = moodEmoji,
                    style = TextStyle(fontSize = 48.sp)
                )
                
                Spacer(modifier = GlanceModifier.height(8.dp))
                
                // Mood Label
                Text(
                    text = moodLabel,
                    style = TextStyle(
                        fontSize = 16.sp,
                        fontWeight = FontWeight.Bold,
                        color = ColorProvider(textColor)
                    )
                )
                
                Spacer(modifier = GlanceModifier.height(4.dp))
                
                // Today label
                Text(
                    text = "Bugün",
                    style = TextStyle(
                        fontSize = 12.sp,
                        color = ColorProvider(secondaryTextColor)
                    )
                )
                
                // Note if exists
                if (moodNote.isNotEmpty() && hasEntry) {
                    Spacer(modifier = GlanceModifier.height(8.dp))
                    Text(
                        text = moodNote,
                        style = TextStyle(
                            fontSize = 11.sp,
                            color = ColorProvider(secondaryTextColor)
                        ),
                        maxLines = 2
                    )
                }
                
                // Tap to add prompt if no entry
                if (!hasEntry) {
                    Spacer(modifier = GlanceModifier.height(8.dp))
                    Text(
                        text = "Eklemek için dokun",
                        style = TextStyle(
                            fontSize = 11.sp,
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

class MoodWidgetReceiver : GlanceAppWidgetReceiver() {
    override val glanceAppWidget: GlanceAppWidget = MoodWidget()
}
