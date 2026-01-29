import WidgetKit
import SwiftUI

struct AllStreaksEntry: TimelineEntry {
    let date: Date
    let streaks: [WidgetDataProvider.HabitStreak]
}

struct AllStreaksProvider: TimelineProvider {
    func placeholder(in context: Context) -> AllStreaksEntry {
        AllStreaksEntry(date: Date(), streaks: WidgetDataProvider.getAllStreaks())
    }
    
    func getSnapshot(in context: Context, completion: @escaping (AllStreaksEntry) -> Void) {
        let entry = AllStreaksEntry(date: Date(), streaks: WidgetDataProvider.getAllStreaks())
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<AllStreaksEntry>) -> Void) {
        let entry = AllStreaksEntry(date: Date(), streaks: WidgetDataProvider.getAllStreaks())
        let nextUpdate = Calendar.current.date(byAdding: .minute, value: 30, to: Date())!
        let timeline = Timeline(entries: [entry], policy: .after(nextUpdate))
        completion(timeline)
    }
}

struct AllStreaksWidgetView: View {
    var entry: AllStreaksEntry
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.widgetFamily) var family
    
    var body: some View {
        let streaks = entry.streaks
        let maxItems = family == .systemLarge ? 10 : 4
        
        VStack(alignment: .leading, spacing: 10) {
            // Header
            HStack {
                Text("🔥")
                    .font(.title3)
                Text("Streak'lerim")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.widgetText)
                Spacer()
            }
            .padding(.bottom, 2)
            
            if !streaks.isEmpty {
                VStack(spacing: 6) {
                    ForEach(streaks.prefix(maxItems)) { habit in
                        HStack {
                            Text(habit.emoji)
                                .font(.caption)
                            Text(habit.name)
                                .font(.caption)
                                .foregroundColor(.widgetText)
                                .lineLimit(1)
                            Spacer()
                            Text("🔥 \(habit.streak)")
                                .font(.caption)
                                .fontWeight(.bold)
                                .foregroundColor(.widgetFire)
                        }
                    }
                }
                
                if streaks.count > maxItems {
                    Spacer()
                    Text("+\(streaks.count - maxItems) daha")
                        .font(.caption2)
                        .foregroundColor(.widgetSecondaryText)
                }
            } else {
                Spacer()
                VStack(alignment: .center) {
                    Text("Henüz streak yok")
                        .font(.subheadline)
                        .foregroundColor(.widgetSecondaryText)
                    Text("Alışkanlıklarınızı tamamlayın!")
                        .font(.caption)
                        .foregroundColor(.widgetAccent)
                }
                .frame(maxWidth: .infinity)
                Spacer()
            }
            
            Spacer()
        }
        .padding()
        .containerBackground(for: .widget) {
            Color.widgetBackground
        }
    }
}

struct AllStreaksWidget: Widget {
    let kind: String = "AllStreaksWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: AllStreaksProvider()) { entry in
            AllStreaksWidgetView(entry: entry)
        }
        .configurationDisplayName("Tüm Streak'ler")
        .description("Tüm alışkanlıkların streak'lerini gösterir")
        .supportedFamilies([.systemMedium, .systemLarge])
    }
}

#Preview(as: .systemMedium) {
    AllStreaksWidget()
} timeline: {
    AllStreaksEntry(date: Date(), streaks: WidgetDataProvider.getAllStreaks())
}
