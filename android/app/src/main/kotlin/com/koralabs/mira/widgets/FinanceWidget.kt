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
import java.text.NumberFormat
import java.util.Locale

/**
 * Finance Widget
 * Shows today's income, expense, and net balance
 */
class FinanceWidget : GlanceAppWidget() {
    
    override suspend fun provideGlance(context: Context, id: GlanceId) {
        val prefs = context.getSharedPreferences("FlutterSharedPreferences", Context.MODE_PRIVATE)
        
        provideContent {
            FinanceContent(prefs)
        }
    }
    
    @Composable
    private fun FinanceContent(prefs: SharedPreferences) {
        val isDark = prefs.getString("flutter.theme_is_dark", "false") == "true"
        val primaryColor = prefs.getString("flutter.theme_primary_color", "#5B6B4F") ?: "#5B6B4F"
        
        val income = prefs.getString("flutter.finance_income", "0")?.toDoubleOrNull() ?: 0.0
        val expense = prefs.getString("flutter.finance_expense", "0")?.toDoubleOrNull() ?: 0.0
        val balance = prefs.getString("flutter.finance_balance", "0")?.toDoubleOrNull() ?: 0.0
        val currency = prefs.getString("flutter.finance_currency", "₺") ?: "₺"
        
        val backgroundColor = if (isDark) Color(0xFF1E1E1E) else Color(0xFFFFFFFF)
        val textColor = if (isDark) Color(0xFFE0E0E0) else Color(0xFF1A1A1A)
        val secondaryTextColor = if (isDark) Color(0xFF9E9E9E) else Color(0xFF666666)
        val incomeColor = Color(0xFF4CAF50)
        val expenseColor = Color(0xFFE53935)
        
        val formatter = NumberFormat.getNumberInstance(Locale("tr", "TR"))
        
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
                        text = "💰",
                        style = TextStyle(fontSize = 20.sp)
                    )
                    Spacer(modifier = GlanceModifier.width(8.dp))
                    Text(
                        text = "Bugün",
                        style = TextStyle(
                            fontSize = 14.sp,
                            fontWeight = FontWeight.Bold,
                            color = ColorProvider(textColor)
                        )
                    )
                }
                
                Spacer(modifier = GlanceModifier.height(12.dp))
                
                // Income
                Row(
                    modifier = GlanceModifier.fillMaxWidth(),
                    horizontalAlignment = Alignment.Horizontal.Start
                ) {
                    Text(
                        text = "+$currency${formatter.format(income)}",
                        style = TextStyle(
                            fontSize = 16.sp,
                            fontWeight = FontWeight.Medium,
                            color = ColorProvider(incomeColor)
                        )
                    )
                }
                
                Spacer(modifier = GlanceModifier.height(4.dp))
                
                // Expense
                Row(
                    modifier = GlanceModifier.fillMaxWidth(),
                    horizontalAlignment = Alignment.Horizontal.Start
                ) {
                    Text(
                        text = "-$currency${formatter.format(expense)}",
                        style = TextStyle(
                            fontSize = 16.sp,
                            fontWeight = FontWeight.Medium,
                            color = ColorProvider(expenseColor)
                        )
                    )
                }
                
                Spacer(modifier = GlanceModifier.height(8.dp))
                
                // Divider line (simulated)
                Box(
                    modifier = GlanceModifier
                        .fillMaxWidth()
                        .height(1.dp)
                        .background(if (isDark) Color(0xFF424242) else Color(0xFFE0E0E0))
                ) {}
                
                Spacer(modifier = GlanceModifier.height(8.dp))
                
                // Net Balance
                val balanceColor = if (balance >= 0) incomeColor else expenseColor
                val balancePrefix = if (balance >= 0) "+" else ""
                Text(
                    text = "Net: $balancePrefix$currency${formatter.format(balance)}",
                    style = TextStyle(
                        fontSize = 14.sp,
                        fontWeight = FontWeight.Bold,
                        color = ColorProvider(balanceColor)
                    )
                )
            }
        }
    }
}

class FinanceWidgetReceiver : GlanceAppWidgetReceiver() {
    override val glanceAppWidget: GlanceAppWidget = FinanceWidget()
}
