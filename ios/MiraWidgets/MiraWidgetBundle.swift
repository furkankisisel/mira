import WidgetKit
import SwiftUI

@main
struct MiraWidgetBundle: WidgetBundle {
    var body: some Widget {
        LiveRhythmWidget()
        FinanceWidget()
        MoodWidget()
        SingleStreakWidget()
        AllStreaksWidget()
    }
}
