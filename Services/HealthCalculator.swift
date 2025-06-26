import Foundation

struct HealthCalculator {
    
    func calculateBMI(weight: Double, height: Double, isMetric: Bool) -> Double {
        guard weight > 0, height > 0 else { return 0 }
        
        if isMetric {
            let heightInMeters = height / 100
            return weight / (heightInMeters * heightInMeters)
        } else {
            return (weight / (height * height)) * 703
        }
    }
    
    func getBMICategory(bmi: Double) -> BMICategory {
        switch bmi {
        case ..<16.0:
            return .severelyUnderweight
        case 16.0..<18.5:
            return .underweight
        case 18.5..<25.0:
            return .normal
        case 25.0..<30.0:
            return .overweight
        case 30.0..<40.0:
            return .obese
        default:
            return .severelyObese
        }
    }
    
    func calculateBMR(weight: Double, height: Double, age: Int, gender: Gender, isMetric: Bool) -> Double {
        let weightKg: Double
        let heightCm: Double
        
        if isMetric {
            weightKg = weight
            heightCm = height
        } else {
            weightKg = weight * 0.453592
            heightCm = height * 2.54
        }
        
        switch gender {
        case .male:
            return (10 * weightKg) + (6.25 * heightCm) - (5 * Double(age)) + 5
        case .female:
            return (10 * weightKg) + (6.25 * heightCm) - (5 * Double(age)) - 161
        case .other:
            let maleBMR = (10 * weightKg) + (6.25 * heightCm) - (5 * Double(age)) + 5
            let femaleBMR = (10 * weightKg) + (6.25 * heightCm) - (5 * Double(age)) - 161
            return (maleBMR + femaleBMR) / 2
        }
    }
    
    func calculateIdealWeight(height: Double, gender: Gender, isMetric: Bool) -> Double {
        let heightCm: Double
        
        if isMetric {
            heightCm = height
        } else {
            heightCm = height * 2.54
        }
        
        let heightInches = heightCm / 2.54
        
        switch gender {
        case .male:
            if heightInches <= 60 {
                return isMetric ? 52 : 114.4
            } else {
                let baseWeight = isMetric ? 52 : 114.4
                let additionalWeight = (heightInches - 60) * (isMetric ? 1.9 : 4.2)
                return baseWeight + additionalWeight
            }
        case .female:
            if heightInches <= 60 {
                return isMetric ? 49 : 107.8
            } else {
                let baseWeight = isMetric ? 49 : 107.8
                let additionalWeight = (heightInches - 60) * (isMetric ? 1.7 : 3.7)
                return baseWeight + additionalWeight
            }
        case .other:
            let maleIdeal = calculateIdealWeight(height: height, gender: .male, isMetric: isMetric)
            let femaleIdeal = calculateIdealWeight(height: height, gender: .female, isMetric: isMetric)
            return (maleIdeal + femaleIdeal) / 2
        }
    }
    
    func calculateBodyFat(bmi: Double, age: Int, gender: Gender) -> Double {
        switch gender {
        case .male:
            return (1.20 * bmi) + (0.23 * Double(age)) - 16.2
        case .female:
            return (1.20 * bmi) + (0.23 * Double(age)) - 5.4
        case .other:
            let maleBodyFat = (1.20 * bmi) + (0.23 * Double(age)) - 16.2
            let femaleBodyFat = (1.20 * bmi) + (0.23 * Double(age)) - 5.4
            return (maleBodyFat + femaleBodyFat) / 2
        }
    }
    
    func calculateTDEE(bmr: Double, activityLevel: ActivityLevel) -> Double {
        return bmr * activityLevel.multiplier
    }
    
    func formatWeight(_ weight: Double, isMetric: Bool) -> String {
        if isMetric {
            return String(format: "%.1f kg", weight)
        } else {
            return String(format: "%.1f lbs", weight)
        }
    }
    
    func formatHeight(_ height: Double, isMetric: Bool) -> String {
        if isMetric {
            return String(format: "%.0f cm", height)
        } else {
            let feet = Int(height) / 12
            let inches = Int(height) % 12
            return "\(feet)' \(inches)\""
        }
    }
}