import WidgetKit
import SwiftUI

struct MoodEntry: TimelineEntry {
    let date: Date
    let data: WidgetDataProvider.MoodData
}

struct MoodProvider: TimelineProvider {
    func placeholder(in context: Context) -> MoodEntry {
        MoodEntry(date: Date(), data: WidgetDataProvider.getMoodData())
    }
    
    func getSnapshot(in context: Context, completion: @escaping (MoodEntry) -> Void) {
        let entry = MoodEntry(date: Date(), data: WidgetDataProvider.getMoodData())
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<MoodEntry>) -> Void) {
        let entry = MoodEntry(date: Date(), data: WidgetDataProvider.getMoodData())
        let nextUpdate = Calendar.current.date(byAdding: .minute, value: 30, to: Date())!
        let timeline = Timeline(entries: [entry], policy: .after(nextUpdate))
        completion(timeline)
    }
}

struct MoodWidgetView: View {
    var entry: MoodEntry
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        let data = entry.data
        
        VStack(spacing: 8) {
            // Large Emoji
            Text(data.emoji)
                .font(.system(size: 40))
            
            // Mood Label
            Text(data.label)
                .font(.subheadline)
                .fontWeight(.bold)
                .foregroundColor(.widgetText)
            
            Text("Bugün")
                .font(.caption2)
                .foregroundColor(.widgetSecondaryText)
            
            if data.hasEntry && !data.note.isEmpty {
                Text(data.note)
                    .font(.caption2)
                    .foregroundColor(.widgetSecondaryText)
                    .lineLimit(1)
                    .multilineTextAlignment(.center)
            } else if !data.hasEntry {
                Text("Eklemek için dokun")
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

struct MoodWidget: Widget {
    let kind: String = "MoodWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: MoodProvider()) { entry in
            MoodWidgetView(entry: entry)
        }
        .configurationDisplayName("Duygu Durumu")
        .description("Bugünkü duygu durumunuzu gösterir")
        .supportedFamilies([.systemSmall])
    }
}

#Preview(as: .systemSmall) {
    MoodWidget()
} timeline: {
    MoodEntry(date: Date(), data: WidgetDataProvider.getMoodData())
}
