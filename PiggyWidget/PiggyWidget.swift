//
//  PiggyWidget.swift
//  PiggyWidget
//
//  Created by Pedro on 1/6/25.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), goal: sampleGoal)
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), goal: sampleGoal)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let entries = [SimpleEntry(date: Date(), goal: loadPrimaryGoal())]
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
    
    private func loadPrimaryGoal() -> Goal? {
        guard let data = UserDefaults(suiteName: "group.com.ngen.piggy")?.data(forKey: "piggy_goals"),
              let goals = try? JSONDecoder().decode([Goal].self, from: data),
              let firstGoal = goals.first else {
            return nil
        }
        return firstGoal
    }
    
    private var sampleGoal: Goal {
        Goal(name: "Sample Goal", targetAmount: 1000, currentAmount: 750)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let goal: Goal?
}

struct PiggyWidgetEntryView : View {
    var entry: Provider.Entry
    
    @Environment(\.widgetFamily) var widgetFamily
    
    var body: some View {
        if let goal = entry.goal {
            VStack(spacing: 12) {
                HStack {
                    Image(systemName: "plus.circle.fill")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .foregroundColor(.pink)
                    
                    Text(goal.name)
                        .font(.headline)
                        .lineLimit(1)
                }
                
                VStack(spacing: 4) {
                    Text("$\(Int(goal.currentAmount))")
                        .font(.system(size: 34, weight: .bold))
                        .foregroundColor(.green)
                    
                    Text("/ $\(Int(goal.targetAmount))")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                ProgressView(value: goal.currentAmount, total: goal.targetAmount)
                    .tint(.blue)
            }
            .padding()
            .background(Color(uiColor: .systemBackground))
            .widgetBackground(Color(uiColor: .systemBackground))
        } else {
            Text("Add a savings goal!")
                .font(.headline)
                .background(Color(uiColor: .systemBackground))
                .widgetBackground(Color(uiColor: .systemBackground))
        }
    }
}

struct PiggyWidget: Widget {
    let kind: String = "PiggyWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            PiggyWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Savings Goal")
        .description("Track your savings progress")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

struct PiggyWidget_Previews: PreviewProvider {
    static var previews: some View {
        PiggyWidgetEntryView(entry: SimpleEntry(
            date: Date(),
            goal: Goal(name: "New Car", targetAmount: 20000, currentAmount: 5000)
        ))
        .previewContext(WidgetPreviewContext(family: .systemSmall))
        
        PiggyWidgetEntryView(entry: SimpleEntry(
            date: Date(),
            goal: Goal(name: "New Car", targetAmount: 20000, currentAmount: 5000)
        ))
        .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}

extension View {
    func widgetBackground(_ background: some View) -> some View {
        if #available(iOSApplicationExtension 17.0, *) {
            return containerBackground(for: .widget) {
                background
            }
        } else {
            return background
        }
    }
}
