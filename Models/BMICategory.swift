import SwiftUI

enum BMICategory: String, Codable, CaseIterable {
    case severelyUnderweight = "severelyUnderweight"
    case underweight = "underweight"
    case normal = "normal"
    case overweight = "overweight"
    case obese = "obese"
    case severelyObese = "severelyObese"
    
    var name: String {
        switch self {
        case .severelyUnderweight: return "Severely Underweight"
        case .underweight: return "Underweight"
        case .normal: return "Normal"
        case .overweight: return "Overweight"
        case .obese: return "Obese"
        case .severelyObese: return "Severely Obese"
        }
    }
    
    var color: Color {
        switch self {
        case .severelyUnderweight: return Color(red: 0.4, green: 0.6, blue: 0.9)
        case .underweight: return Color(red: 0.35, green: 0.78, blue: 0.98)
        case .normal: return Color(red: 0.2, green: 0.78, blue: 0.35)
        case .overweight: return Color(red: 1.0, green: 0.58, blue: 0.0)
        case .obese: return Color(red: 1.0, green: 0.23, blue: 0.19)
        case .severelyObese: return Color(red: 0.8, green: 0.0, blue: 0.0)
        }
    }
    
    var gradient: LinearGradient {
        switch self {
        case .severelyUnderweight:
            return LinearGradient(colors: [color.opacity(0.8), color], startPoint: .topLeading, endPoint: .bottomTrailing)
        case .underweight:
            return LinearGradient(colors: [color.opacity(0.8), color], startPoint: .topLeading, endPoint: .bottomTrailing)
        case .normal:
            return LinearGradient(colors: [color.opacity(0.8), color], startPoint: .topLeading, endPoint: .bottomTrailing)
        case .overweight:
            return LinearGradient(colors: [color.opacity(0.8), color], startPoint: .topLeading, endPoint: .bottomTrailing)
        case .obese:
            return LinearGradient(colors: [color.opacity(0.8), color], startPoint: .topLeading, endPoint: .bottomTrailing)
        case .severelyObese:
            return LinearGradient(colors: [color.opacity(0.8), color], startPoint: .topLeading, endPoint: .bottomTrailing)
        }
    }
    
    var icon: String {
        switch self {
        case .severelyUnderweight, .underweight: return "arrow.down.circle.fill"
        case .normal: return "checkmark.circle.fill"
        case .overweight: return "arrow.up.circle.fill"
        case .obese, .severelyObese: return "exclamationmark.triangle.fill"
        }
    }
    
    var range: String {
        switch self {
        case .severelyUnderweight: return "BMI < 16.0"
        case .underweight: return "BMI 16.0 - 18.4"
        case .normal: return "BMI 18.5 - 24.9"
        case .overweight: return "BMI 25.0 - 29.9"
        case .obese: return "BMI 30.0 - 39.9"
        case .severelyObese: return "BMI ≥ 40.0"
        }
    }
    
    var healthTip: String {
        switch self {
        case .severelyUnderweight:
            return "Your BMI indicates you're severely underweight. Please consult a healthcare professional for personalized advice."
        case .underweight:
            return "You're underweight. Consider increasing caloric intake with nutritious foods and strength training."
        case .normal:
            return "Great! You're at a healthy weight. Maintain it with balanced nutrition and regular exercise."
        case .overweight:
            return "You're slightly overweight. Small lifestyle changes in diet and exercise can help you reach a healthier weight."
        case .obese:
            return "Your BMI indicates obesity. Consider consulting a healthcare provider for a personalized weight management plan."
        case .severelyObese:
            return "Your BMI indicates severe obesity. Please seek medical advice for safe and effective weight management."
        }
    }
}