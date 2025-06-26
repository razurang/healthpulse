import SwiftUI
import SwiftData
import Charts

struct HistoryView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \HealthRecord.date, order: .reverse) private var records: [HealthRecord]
    @State private var selectedTimeRange: TimeRange = .month
    @State private var selectedRecord: HealthRecord?
    @State private var showingDeleteAlert = false
    
    enum TimeRange: String, CaseIterable {
        case week = "Week"
        case month = "Month"
        case year = "Year"
        case all = "All"
        
        var days: Int {
            switch self {
            case .week: return 7
            case .month: return 30
            case .year: return 365
            case .all: return Int.max
            }
        }
    }
    
    var filteredRecords: [HealthRecord] {
        guard selectedTimeRange != .all else { return records }
        
        let cutoffDate = Calendar.current.date(byAdding: .day, value: -selectedTimeRange.days, to: Date()) ?? Date()
        return records.filter { $0.date >= cutoffDate }
    }
    
    var body: some View {
        NavigationStack {
            Group {
                if records.isEmpty {
                    emptyStateView
                } else {
                    ScrollView {
                        VStack(spacing: 20) {
                            timeRangePicker
                            
                            if !filteredRecords.isEmpty {
                                bmiChartCard
                                weightChartCard
                                recordsList
                            } else {
                                noDataForRangeView
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("History")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                if !records.isEmpty {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("Clear All", systemImage: "trash") {
                            showingDeleteAlert = true
                        }
                        .foregroundStyle(.red)
                    }
                }
            }
            .alert("Delete All Records?", isPresented: $showingDeleteAlert) {
                Button("Cancel", role: .cancel) { }
                Button("Delete", role: .destructive) {
                    deleteAllRecords()
                }
            } message: {
                Text("This action cannot be undone.")
            }
        }
    }
    
    private var emptyStateView: some View {
        ContentUnavailableView {
            Label("No Health Records", systemImage: "chart.line.downtrend.xyaxis")
        } description: {
            Text("Start calculating your health metrics to see trends over time.")
        }
    }
    
    private var noDataForRangeView: some View {
        ContentUnavailableView {
            Label("No Data for Selected Range", systemImage: "calendar.badge.exclamationmark")
        } description: {
            Text("Try selecting a different time range to see your health records.")
        }
        .frame(height: 300)
    }
    
    private var timeRangePicker: some View {
        Picker("Time Range", selection: $selectedTimeRange) {
            ForEach(TimeRange.allCases, id: \.self) { range in
                Text(range.rawValue).tag(range)
            }
        }
        .pickerStyle(.segmented)
    }
    
    private var bmiChartCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("BMI Trend")
                .font(.headline)
            
            Chart(filteredRecords) { record in
                LineMark(
                    x: .value("Date", record.date),
                    y: .value("BMI", record.bmi)
                )
                .foregroundStyle(Color.accent)
                .lineStyle(StrokeStyle(lineWidth: 3))
                .symbol {
                    Circle()
                        .fill(record.bmiCategory.color)
                        .frame(width: 8, height: 8)
                }
                
                AreaMark(
                    x: .value("Date", record.date),
                    y: .value("BMI", record.bmi)
                )
                .foregroundStyle(
                    LinearGradient(
                        colors: [Color.accent.opacity(0.3), Color.accent.opacity(0.05)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
            }
            .frame(height: 200)
            .chartYScale(domain: 15...35)
            .chartXAxis {
                AxisMarks(values: .automatic(desiredCount: 5)) { _ in
                    AxisGridLine()
                    AxisValueLabel(format: .dateTime.month().day())
                }
            }
            .chartYAxis {
                AxisMarks { value in
                    AxisGridLine()
                    AxisValueLabel {
                        if let bmi = value.as(Double.self) {
                            Text("\(Int(bmi))")
                        }
                    }
                }
            }
            .overlay(alignment: .topTrailing) {
                if let lastRecord = filteredRecords.first {
                    VStack(alignment: .trailing) {
                        Text("Current")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        Text(String(format: "%.1f", lastRecord.bmi))
                            .font(.title3)
                            .fontWeight(.bold)
                    }
                    .padding(8)
                    .background(Color(.systemBackground).opacity(0.9))
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.05), radius: 5)
    }
    
    private var weightChartCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Weight Trend")
                .font(.headline)
            
            Chart(filteredRecords) { record in
                LineMark(
                    x: .value("Date", record.date),
                    y: .value("Weight", record.weight)
                )
                .foregroundStyle(Color.green)
                .lineStyle(StrokeStyle(lineWidth: 3))
                .symbol {
                    Circle()
                        .fill(Color.green)
                        .frame(width: 6, height: 6)
                }
                
                if let index = filteredRecords.firstIndex(where: { $0.id == record.id }),
                   index < filteredRecords.count - 1 {
                    let nextRecord = filteredRecords[index + 1]
                    let change = record.weight - nextRecord.weight
                    
                    if change != 0 {
                        PointMark(
                            x: .value("Date", record.date),
                            y: .value("Weight", record.weight)
                        )
                        .annotation(position: change > 0 ? .top : .bottom) {
                            Text(String(format: "%+.1f", change))
                                .font(.caption2)
                                .foregroundStyle(change > 0 ? .red : .green)
                        }
                    }
                }
            }
            .frame(height: 200)
            .chartXAxis {
                AxisMarks(values: .automatic(desiredCount: 5)) { _ in
                    AxisGridLine()
                    AxisValueLabel(format: .dateTime.month().day())
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.05), radius: 5)
    }
    
    private var recordsList: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Recent Records")
                .font(.headline)
                .padding(.horizontal)
            
            ForEach(filteredRecords.prefix(10)) { record in
                RecordRow(record: record, onDelete: {
                    deleteRecord(record)
                })
            }
        }
    }
    
    private func deleteRecord(_ record: HealthRecord) {
        withAnimation {
            modelContext.delete(record)
            try? modelContext.save()
        }
    }
    
    private func deleteAllRecords() {
        withAnimation {
            for record in records {
                modelContext.delete(record)
            }
            try? modelContext.save()
        }
    }
}

struct RecordRow: View {
    let record: HealthRecord
    let onDelete: () -> Void
    @State private var showingDetails = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(record.date, style: .date)
                        .font(.subheadline)
                        .fontWeight(.medium)
                    
                    Text(record.date, style: .time)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    HStack(spacing: 4) {
                        Text("BMI")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        Text(String(format: "%.1f", record.bmi))
                            .font(.headline)
                            .foregroundStyle(record.bmiCategory.color)
                    }
                    
                    Text(record.bmiCategory.name)
                        .font(.caption2)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 2)
                        .background(record.bmiCategory.color.opacity(0.2))
                        .clipShape(Capsule())
                }
            }
            
            if showingDetails {
                Divider()
                
                HStack(spacing: 20) {
                    DetailItem(label: "Weight", value: HealthCalculator().formatWeight(record.weight, isMetric: record.measurementSystem == .metric))
                    DetailItem(label: "Height", value: HealthCalculator().formatHeight(record.height, isMetric: record.measurementSystem == .metric))
                    DetailItem(label: "Age", value: "\(record.age) years")
                }
                .font(.caption)
                
                Button(action: onDelete) {
                    Label("Delete", systemImage: "trash")
                        .font(.caption)
                        .foregroundStyle(.red)
                }
                .padding(.top, 4)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .contentShape(Rectangle())
        .onTapGesture {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                showingDetails.toggle()
            }
        }
    }
}

struct DetailItem: View {
    let label: String
    let value: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(label)
                .foregroundStyle(.secondary)
            Text(value)
                .fontWeight(.medium)
        }
    }
}

#Preview {
    HistoryView()
        .modelContainer(for: [HealthRecord.self, UserProfile.self], inMemory: true)
}