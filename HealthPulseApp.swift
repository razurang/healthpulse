import SwiftUI
import SwiftData
import TipKit

@main
struct HealthPulseApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            HealthRecord.self,
            UserProfile.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        
        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding = false
    @AppStorage("preferredUnits") private var preferredUnits: MeasurementSystem = .metric
    @AppStorage("colorScheme") private var colorScheme: ColorSchemeOption = .system
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(colorScheme.value)
                .task {
                    TipsManager.shared.configureTips()
                }
        }
        .modelContainer(sharedModelContainer)
    }
}

enum MeasurementSystem: String, Codable, CaseIterable {
    case metric = "metric"
    case imperial = "imperial"
    
    var name: String {
        switch self {
        case .metric: return "Metric"
        case .imperial: return "Imperial"
        }
    }
}

enum ColorSchemeOption: String, CaseIterable {
    case system = "system"
    case light = "light"
    case dark = "dark"
    
    var value: ColorScheme? {
        switch self {
        case .system: return nil
        case .light: return .light
        case .dark: return .dark
        }
    }
    
    var name: String {
        switch self {
        case .system: return "System"
        case .light: return "Light"
        case .dark: return "Dark"
        }
    }
}