import Foundation
import WidgetKit

/// Shared data provider for reading widget data from UserDefaults
struct WidgetDataProvider {
    
    static let appGroupId = "group.com.koralabs.mira.widgets"
    
    static var sharedDefaults: UserDefaults? {
        UserDefaults(suiteName: appGroupId)
    }
    
    // MARK: - Theme Data
    
    static var isDarkMode: Bool {
        sharedDefaults?.bool(forKey: "theme_is_dark") ?? false
    }
    
    static var primaryColor: String {
        sharedDefaults?.string(forKey: "theme_primary_color") ?? "#5B6B4F"
    }
    
    static var backgroundColor: UIColor {
        if isDarkMode {
            return UIColor(red: 0x1E/255, green: 0x1E/255, blue: 0x1E/255, alpha: 1)
        } else {
            return UIColor(red: 0xFF/255, green: 0xFF/255, blue: 0xFF/255, alpha: 1)
        }
    }
    
    static var textColor: UIColor {
        if isDarkMode {
            return UIColor(red: 0xE0/255, green: 0xE0/255, blue: 0xE0/255, alpha: 1)
        } else {
            return UIColor(red: 0x1A/255, green: 0x1A/255, blue: 0x1A/255, alpha: 1)
        }
    }
    
    static var secondaryTextColor: UIColor {
        if isDarkMode {
            return UIColor(red: 0x9E/255, green: 0x9E/255, blue: 0x9E/255, alpha: 1)
        } else {
            return UIColor(red: 0x66/255, green: 0x66/255, blue: 0x66/255, alpha: 1)
        }
    }
    
    // MARK: - Live Rhythm Data
    
    struct RhythmData {
        let window: String
        let emoji: String
        let windowName: String
        let nextTransition: String
        let focusHabitName: String
        let focusHabitEmoji: String
        let focusProgress: Int
        let focusTarget: Int
        let aiMessage: String
    }
    
    static func getRhythmData() -> RhythmData {
        let defaults = sharedDefaults
        return RhythmData(
            window: defaults?.string(forKey: "rhythm_window") ?? "reflection",
            emoji: defaults?.string(forKey: "rhythm_emoji") ?? "🌙",
            windowName: defaults?.string(forKey: "rhythm_window_name") ?? "Yansıma Zamanı",
            nextTransition: defaults?.string(forKey: "rhythm_next_transition") ?? "",
            focusHabitName: defaults?.string(forKey: "focus_habit_name") ?? "",
            focusHabitEmoji: defaults?.string(forKey: "focus_habit_emoji") ?? "📌",
            focusProgress: defaults?.integer(forKey: "focus_habit_progress") ?? 0,
            focusTarget: defaults?.integer(forKey: "focus_habit_target") ?? 1,
            aiMessage: defaults?.string(forKey: "focus_habit_ai_message") ?? ""
        )
    }
    
    // MARK: - Finance Data
    
    struct FinanceData {
        let income: Double
        let expense: Double
        let balance: Double
        let currency: String
    }
    
    static func getFinanceData() -> FinanceData {
        let defaults = sharedDefaults
        return FinanceData(
            income: defaults?.double(forKey: "finance_income") ?? 0,
            expense: defaults?.double(forKey: "finance_expense") ?? 0,
            balance: defaults?.double(forKey: "finance_balance") ?? 0,
            currency: defaults?.string(forKey: "finance_currency") ?? "₺"
        )
    }
    
    // MARK: - Mood Data
    
    struct MoodData {
        let hasEntry: Bool
        let value: Int
        let emoji: String
        let label: String
        let note: String
    }
    
    static func getMoodData() -> MoodData {
        let defaults = sharedDefaults
        return MoodData(
            hasEntry: defaults?.bool(forKey: "mood_has_entry") ?? false,
            value: defaults?.integer(forKey: "mood_value") ?? 0,
            emoji: defaults?.string(forKey: "mood_emoji") ?? "❓",
            label: defaults?.string(forKey: "mood_label") ?? "Henüz kayıt yok",
            note: defaults?.string(forKey: "mood_note") ?? ""
        )
    }
    
    // MARK: - Streak Data
    
    struct HabitStreak: Identifiable {
        let id: String
        let name: String
        let emoji: String
        let streak: Int
    }
    
    struct SingleHabitData {
        let id: String
        let name: String
        let emoji: String
        let streak: Int
    }
    
    static func getSingleHabitData() -> SingleHabitData {
        let defaults = sharedDefaults
        return SingleHabitData(
            id: defaults?.string(forKey: "single_habit_id") ?? "",
            name: defaults?.string(forKey: "single_habit_name") ?? "",
            emoji: defaults?.string(forKey: "single_habit_emoji") ?? "📌",
            streak: defaults?.integer(forKey: "single_habit_streak") ?? 0
        )
    }
    
    static func getAllStreaks() -> [HabitStreak] {
        guard let defaults = sharedDefaults,
              let jsonString = defaults.string(forKey: "habit_streaks"),
              let data = jsonString.data(using: .utf8) else {
            return []
        }
        
        do {
            if let array = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] {
                return array.compactMap { dict in
                    guard let id = dict["id"] as? String,
                          let name = dict["name"] as? String else {
                        return nil
                    }
                    return HabitStreak(
                        id: id,
                        name: name,
                        emoji: dict["emoji"] as? String ?? "📌",
                        streak: dict["streak"] as? Int ?? 0
                    )
                }
            }
        } catch {
            print("Error parsing streaks: \(error)")
        }
        
        return []
    }
    
    // MARK: - Color Helper
    
    static func parseColor(_ hex: String) -> UIColor {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        
        var rgb: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgb)
        
        return UIColor(
            red: CGFloat((rgb & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgb & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgb & 0x0000FF) / 255.0,
            alpha: 1.0
        )
    }
}

// MARK: - SwiftUI Color Extension

extension Color {
    init(uiColor: UIColor) {
        self.init(uiColor)
    }
    
    static var widgetBackground: Color {
        Color(uiColor: WidgetDataProvider.backgroundColor)
    }
    
    static var widgetText: Color {
        Color(uiColor: WidgetDataProvider.textColor)
    }
    
    static var widgetSecondaryText: Color {
        Color(uiColor: WidgetDataProvider.secondaryTextColor)
    }
    
    static var widgetAccent: Color {
        Color(uiColor: WidgetDataProvider.parseColor(WidgetDataProvider.primaryColor))
    }
    
    static var widgetFire: Color {
        Color(red: 0xFF/255, green: 0x57/255, blue: 0x22/255)
    }
    
    static var widgetIncome: Color {
        Color(red: 0x4C/255, green: 0xAF/255, blue: 0x50/255)
    }
    
    static var widgetExpense: Color {
        Color(red: 0xE5/255, green: 0x39/255, blue: 0x35/255)
    }
}
