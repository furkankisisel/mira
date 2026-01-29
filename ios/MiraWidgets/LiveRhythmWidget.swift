import WidgetKit
import SwiftUI

struct LiveRhythmEntry: TimelineEntry {
    let date: Date
    let data: WidgetDataProvider.RhythmData
}

struct LiveRhythmProvider: TimelineProvider {
    func placeholder(in context: Context) -> LiveRhythmEntry {
        LiveRhythmEntry(date: Date(), data: WidgetDataProvider.getRhythmData())
    }
    
    func getSnapshot(in context: Context, completion: @escaping (LiveRhythmEntry) -> Void) {
        let entry = LiveRhythmEntry(date: Date(), data: WidgetDataProvider.getRhythmData())
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<LiveRhythmEntry>) -> Void) {
        let entry = LiveRhythmEntry(date: Date(), data: WidgetDataProvider.getRhythmData())
        // Update every 30 minutes
        let nextUpdate = Calendar.current.date(byAdding: .minute, value: 30, to: Date())!
        let timeline = Timeline(entries: [entry], policy: .after(nextUpdate))
        completion(timeline)
    }
}

struct LiveRhythmWidgetView: View {
    var entry: LiveRhythmEntry
    @Environment(\.widgetFamily) var family
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        let data = entry.data
        let progressPercent = data.focusTarget > 0 ? Double(data.focusProgress) / Double(data.focusTarget) : 0
        
        VStack(alignment: .leading, spacing: 8) {
            // Header
            HStack {
                Text(data.emoji)
                    .font(.title2)
                Text(data.windowName)
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundColor(.widgetText)
                Spacer()
            }
            
            if !data.focusHabitName.isEmpty {
                // Focus habit
                HStack {
                    Text(data.focusHabitEmoji)
                        .font(.callout)
                    Text(data.focusHabitName)
                        .font(.subheadline)
                        .foregroundColor(.widgetText)
                        .lineLimit(1)
                }
                
                // Progress bar
                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color.gray.opacity(0.3))
                            .frame(height: 8)
                        
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color.widgetAccent)
                            .frame(width: geometry.size.width * progressPercent, height: 8)
                    }
                }
                .frame(height: 8)
                
                Text("\(Int(progressPercent * 100))%")
                    .font(.caption2)
                    .foregroundColor(.widgetSecondaryText)
                
                // AI Message
                if !data.aiMessage.isEmpty && family != .systemSmall {
                    Text(data.aiMessage)
                        .font(.caption2)
                        .foregroundColor(.widgetSecondaryText)
                        .lineLimit(2)
                }
            } else {
                Text("Odak alışkanlığı yok")
                    .font(.subheadline)
                    .foregroundColor(.widgetSecondaryText)
                Text("Bir alışkanlığı odak olarak ayarlayın")
                    .font(.caption2)
                    .foregroundColor(.widgetSecondaryText)
            }
            
            Spacer()
        }
        .padding()
        .containerBackground(for: .widget) {
            Color.widgetBackground
        }
    }
}

struct LiveRhythmWidget: Widget {
    let kind: String = "LiveRhythmWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: LiveRhythmProvider()) { entry in
            LiveRhythmWidgetView(entry: entry)
        }
        .configurationDisplayName("Canlı Ritim")
        .description("Canlı ritminizi ve odak alışkanlığınızı gösterir")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

#Preview(as: .systemMedium) {
    LiveRhythmWidget()
} timeline: {
    LiveRhythmEntry(date: Date(), data: WidgetDataProvider.getRhythmData())
}
