import WidgetKit
import SwiftUI

struct SingleStreakEntry: TimelineEntry {
    let date: Date
    let data: WidgetDataProvider.SingleHabitData
}

struct SingleStreakProvider: TimelineProvider {
    func placeholder(in context: Context) -> SingleStreakEntry {
        SingleStreakEntry(date: Date(), data: WidgetDataProvider.getSingleHabitData())
    }
    
    func getSnapshot(in context: Context, completion: @escaping (SingleStreakEntry) -> Void) {
        let entry = SingleStreakEntry(date: Date(), data: WidgetDataProvider.getSingleHabitData())
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<SingleStreakEntry>) -> Void) {
        let entry = SingleStreakEntry(date: Date(), data: WidgetDataProvider.getSingleHabitData())
        let nextUpdate = Calendar.current.date(byAdding: .minute, value: 30, to: Date())!
        let timeline = Timeline(entries: [entry], policy: .after(nextUpdate))
        completion(timeline)
    }
}

struct SingleStreakWidgetView: View {
    var entry: SingleStreakEntry
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        let data = entry.data
        
        VStack(alignment: .center, spacing: 4) {
            if !data.name.isEmpty {
                // Fire + Streak
                HStack(alignment: .bottom, spacing: 2) {
                    Text("🔥")
                        .font(.title2)
                        .padding(.bottom, 4)
                    Text("\(data.streak)")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(.widgetFire)
                }
                
                Text("gün")
                    .font(.caption)
                    .foregroundColor(.widgetSecondaryText)
                
                Spacer()
                    .frame(height: 8)
                
                // Habit Info
                HStack(spacing: 4) {
                    Text(data.emoji)
                        .font(.caption)
                    Text(data.name)
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(.widgetText)
                        .lineLimit(1)
                }
            } else {
                Text("🔥")
                    .font(.largeTitle)
                
                Text("Alışkanlık seçin")
                    .font(.caption)
                    .foregroundColor(.widgetSecondaryText)
                
                Text("Uygulamada ayarlayın")
                    .font(.caption2)
                    .foregroundColor(.widgetAccent)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
        .containerBackground(for: .widget) {
            Color.widgetBackground
        }
    }
}

struct SingleStreakWidget: Widget {
    let kind: String = "SingleStreakWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: SingleStreakProvider()) { entry in
            SingleStreakWidgetView(entry: entry)
        }
        .configurationDisplayName("Alışkanlık Streak")
        .description("Seçilen alışkanlığın streak'ini gösterir")
        .supportedFamilies([.systemSmall])
    }
}

#Preview(as: .systemSmall) {
    SingleStreakWidget()
} timeline: {
    SingleStreakEntry(date: Date(), data: WidgetDataProvider.getSingleHabitData())
}
