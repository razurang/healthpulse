import Foundation
import TipKit
import Observation

struct InputTip: Tip {
    var title: Text {
        Text("Get Started")
    }
    
    var message: Text? {
        Text("Enter your weight, height, age, and gender to calculate your health metrics.")
    }
    
    var image: Image? {
        Image(systemName: "heart.text.square.fill")
    }
    
    var actions: [Action] {
        [
            Action(id: "learn-more", title: "Learn More"),
            Action(id: "dismiss", title: "Got it!")
        ]
    }
}

struct ResultsTip: Tip {
    var title: Text {
        Text("Understanding Your Results")
    }
    
    var message: Text? {
        Text("Your BMI category is color-coded. Green means healthy, orange means overweight, and red means obese.")
    }
    
    var image: Image? {
        Image(systemName: "info.circle.fill")
    }
    
    var actions: [Action] {
        [
            Action(id: "health-tips", title: "Health Tips"),
            Action(id: "dismiss", title: "Got it!")
        ]
    }
}

struct HistoryTip: Tip {
    var title: Text {
        Text("Track Your Progress")
    }
    
    var message: Text? {
        Text("View your health trends over time with interactive charts. Tap on records to see more details.")
    }
    
    var image: Image? {
        Image(systemName: "chart.line.uptrend.xyaxis")
    }
    
    var actions: [Action] {
        [
            Action(id: "view-charts", title: "View Charts"),
            Action(id: "dismiss", title: "Got it!")
        ]
    }
}

struct ShareTip: Tip {
    var title: Text {
        Text("Share Your Results")
    }
    
    var message: Text? {
        Text("Share your health results with your doctor or fitness trainer using the share button.")
    }
    
    var image: Image? {
        Image(systemName: "square.and.arrow.up")
    }
}

struct BMIRangeTip: Tip {
    var title: Text {
        Text("BMI Ranges")
    }
    
    var message: Text? {
        Text("BMI ranges: Underweight (<18.5), Normal (18.5-24.9), Overweight (25-29.9), Obese (30+)")
    }
    
    var image: Image? {
        Image(systemName: "info.circle")
    }
}

struct CalculatorTip: Tip {
    var title: Text {
        Text("Accurate Calculations")
    }
    
    var message: Text? {
        Text("We use WHO-approved formulas for BMI, Harris-Benedict for BMR, and Deurenberg for body fat estimation.")
    }
    
    var image: Image? {
        Image(systemName: "checkmark.seal.fill")
    }
}

@Observable
class TipsManager {
    static let shared = TipsManager()
    
    var inputTip = InputTip()
    var resultsTip = ResultsTip()
    var historyTip = HistoryTip()
    var shareTip = ShareTip()
    var bmiRangeTip = BMIRangeTip()
    var calculatorTip = CalculatorTip()
    
    private init() {}
    
    func configureTips() {
        try? Tips.configure([
            .displayFrequency(.immediate),
            .datastoreLocation(.applicationDefault)
        ])
    }
    
    func resetTips() {
        try? Tips.resetDatastore()
    }
}