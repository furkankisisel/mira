import WidgetKit
import SwiftUI

struct FinanceEntry: TimelineEntry {
    let date: Date
    let data: WidgetDataProvider.FinanceData
}

struct FinanceProvider: TimelineProvider {
    func placeholder(in context: Context) -> FinanceEntry {
        FinanceEntry(date: Date(), data: WidgetDataProvider.getFinanceData())
    }
    
    func getSnapshot(in context: Context, completion: @escaping (FinanceEntry) -> Void) {
        let entry = FinanceEntry(date: Date(), data: WidgetDataProvider.getFinanceData())
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<FinanceEntry>) -> Void) {
        let entry = FinanceEntry(date: Date(), data: WidgetDataProvider.getFinanceData())
        let nextUpdate = Calendar.current.date(byAdding: .minute, value: 30, to: Date())!
        let timeline = Timeline(entries: [entry], policy: .after(nextUpdate))
        completion(timeline)
    }
}

struct FinanceWidgetView: View {
    var entry: FinanceEntry
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        let data = entry.data
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.locale = Locale(identifier: "tr_TR")
        
        VStack(alignment: .leading, spacing: 8) {
            // Header
            HStack {
                Text("💰")
                    .font(.title3)
                Text("Bugün")
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundColor(.widgetText)
                Spacer()
            }
            
            Spacer()
            
            // Income
            Text("+\(data.currency)\(formatter.string(from: NSNumber(value: data.income)) ?? "0")")
                .font(.callout)
                .fontWeight(.medium)
                .foregroundColor(.widgetIncome)
            
            // Expense
            Text("-\(data.currency)\(formatter.string(from: NSNumber(value: data.expense)) ?? "0")")
                .font(.callout)
                .fontWeight(.medium)
                .foregroundColor(.widgetExpense)
            
            Divider()
            
            // Balance
            let balanceColor: Color = data.balance >= 0 ? .widgetIncome : .widgetExpense
            let prefix = data.balance >= 0 ? "+" : ""
            Text("Net: \(prefix)\(data.currency)\(formatter.string(from: NSNumber(value: data.balance)) ?? "0")")
                .font(.subheadline)
                .fontWeight(.bold)
                .foregroundColor(balanceColor)
        }
        .padding()
        .containerBackground(for: .widget) {
            Color.widgetBackground
        }
    }
}

struct FinanceWidget: Widget {
    let kind: String = "FinanceWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: FinanceProvider()) { entry in
            FinanceWidgetView(entry: entry)
        }
        .configurationDisplayName("Bugünün Finansı")
        .description("Bugünkü gelir ve giderlerinizi gösterir")
        .supportedFamilies([.systemSmall])
    }
}

#Preview(as: .systemSmall) {
    FinanceWidget()
} timeline: {
    FinanceEntry(date: Date(), data: WidgetDataProvider.getFinanceData())
}
