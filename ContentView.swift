import SwiftUI
import SwiftData

struct ContentView: View {
    @State private var selectedTab = 0
    @State private var healthViewModel = HealthViewModel()
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        TabView(selection: $selectedTab) {
            InputView(viewModel: healthViewModel)
                .tabItem {
                    Label("Calculate", systemImage: "heart.text.square.fill")
                }
                .tag(0)
            
            HistoryView()
                .tabItem {
                    Label("History", systemImage: "chart.line.uptrend.xyaxis")
                }
                .tag(1)
            
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
                .tag(2)
        }
        .tint(.accent)
    }
}

#Preview {
    ContentView()
        .modelContainer(for: [HealthRecord.self, UserProfile.self], inMemory: true)
}