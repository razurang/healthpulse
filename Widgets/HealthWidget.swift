import WidgetKit
import SwiftUI
import SwiftData

struct HealthWidget: Widget {
    let kind: String = "HealthWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: HealthProvider()) { entry in
            HealthWidgetEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .configurationDisplayName("Health Overview")
        .description("View your latest BMI and health status at a glance.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

struct HealthProvider: TimelineProvider {
    func placeholder(in context: Context) -> HealthEntry {
        HealthEntry(date: Date(), bmi: 22.5, category: .normal, lastUpdated: Date())
    }
    
    func getSnapshot(in context: Context, completion: @escaping (HealthEntry) -> ()) {
        let entry = HealthEntry(date: Date(), bmi: 22.5, category: .normal, lastUpdated: Date())
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<HealthEntry>) -> ()) {
        // In real implementation, fetch latest health record from Core Data
        let currentDate = Date()
        let entry = HealthEntry(date: currentDate, bmi: 22.5, category: .normal, lastUpdated: currentDate)
        
        let timeline = Timeline(entries: [entry], policy: .atEnd)
        completion(timeline)
    }
}

struct HealthEntry: TimelineEntry {
    let date: Date
    let bmi: Double
    let category: BMICategory
    let lastUpdated: Date
}

struct HealthWidgetEntryView: View {
    var entry: HealthProvider.Entry
    @Environment(\.widgetFamily) var family
    
    var body: some View {
        switch family {
        case .systemSmall:
            SmallHealthWidget(entry: entry)
        case .systemMedium:
            MediumHealthWidget(entry: entry)
        default:
            SmallHealthWidget(entry: entry)
        }
    }
}

struct SmallHealthWidget: View {
    let entry: HealthEntry
    
    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Image(systemName: "heart.fill")
                    .foregroundStyle(entry.category.color)
                Spacer()
                Text("BMI")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            VStack(spacing: 4) {
                Text(String(format: "%.1f", entry.bmi))
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundStyle(entry.category.color)
                
                Text(entry.category.name)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            HStack {
                Spacer()
                Text("Updated \(entry.lastUpdated, style: .relative)")
                    .font(.caption2)
                    .foregroundStyle(.tertiary)
            }
        }
        .padding()
    }
}

struct MediumHealthWidget: View {
    let entry: HealthEntry
    
    var body: some View {
        HStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Image(systemName: "heart.text.square.fill")
                        .foregroundStyle(entry.category.color)
                    Text("Health Status")
                        .font(.headline)
                        .fontWeight(.semibold)
                }
                
                Text("BMI: \(String(format: "%.1f", entry.bmi))")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundStyle(entry.category.color)
                
                Text(entry.category.name)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                
                Spacer()
                
                Text("Last updated \(entry.lastUpdated, style: .relative)")
                    .font(.caption)
                    .foregroundStyle(.tertiary)
            }
            
            Spacer()
            
            ZStack {
                Circle()
                    .stroke(Color(.systemGray5), lineWidth: 6)
                    .frame(width: 60, height: 60)
                
                Circle()
                    .trim(from: 0, to: min(entry.bmi / 40, 1))
                    .stroke(entry.category.color, style: StrokeStyle(lineWidth: 6, lineCap: .round))
                    .frame(width: 60, height: 60)
                    .rotationEffect(.degrees(-90))
                
                Image(systemName: entry.category.icon)
                    .font(.title3)
                    .foregroundStyle(entry.category.color)
            }
        }
        .padding()
    }
}

#Preview(as: .systemSmall) {
    HealthWidget()
} timeline: {
    HealthEntry(date: .now, bmi: 22.5, category: .normal, lastUpdated: .now)
    HealthEntry(date: .now, bmi: 27.3, category: .overweight, lastUpdated: .now)
}

#Preview(as: .systemMedium) {
    HealthWidget()
} timeline: {
    HealthEntry(date: .now, bmi: 22.5, category: .normal, lastUpdated: .now)
}