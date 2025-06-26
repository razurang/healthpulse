import AppIntents
import SwiftUI

struct CalculateBMIIntent: AppIntent {
    static var title: LocalizedStringResource = "Calculate BMI"
    static var description = IntentDescription("Calculate your Body Mass Index")
    static var openAppWhenRun: Bool = true
    
    @Parameter(title: "Weight")
    var weight: Double
    
    @Parameter(title: "Height")
    var height: Double
    
    @Parameter(title: "Is Metric", default: true)
    var isMetric: Bool
    
    func perform() async throws -> some IntentResult & ProvidesDialog {
        let calculator = HealthCalculator()
        let bmi = calculator.calculateBMI(weight: weight, height: height, isMetric: isMetric)
        let category = calculator.getBMICategory(bmi: bmi)
        
        return .result(
            dialog: IntentDialog("Your BMI is \(String(format: "%.1f", bmi)), which is considered \(category.name.lowercased()).")
        )
    }
}

struct GetLastBMIIntent: AppIntent {
    static var title: LocalizedStringResource = "Get Last BMI"
    static var description = IntentDescription("Get your most recent BMI calculation")
    
    func perform() async throws -> some IntentResult & ProvidesDialog {
        // In a real implementation, you would fetch from SwiftData
        // For now, return a placeholder
        return .result(
            dialog: IntentDialog("Your last BMI was 22.5, which is considered normal. Open the app to see more details.")
        )
    }
}

struct HealthShortcuts: AppShortcutsProvider {
    static var appShortcuts: [AppShortcut] {
        AppShortcut(
            intent: CalculateBMIIntent(),
            phrases: [
                "Calculate my BMI with \(.applicationName)",
                "What's my BMI in \(.applicationName)",
                "Check my body mass index"
            ],
            shortTitle: "Calculate BMI",
            systemImageName: "heart.text.square.fill"
        )
        
        AppShortcut(
            intent: GetLastBMIIntent(),
            phrases: [
                "What was my last BMI in \(.applicationName)",
                "Show my recent health data in \(.applicationName)",
                "Get my last health check from \(.applicationName)"
            ],
            shortTitle: "Last BMI",
            systemImageName: "clock.fill"
        )
    }
}