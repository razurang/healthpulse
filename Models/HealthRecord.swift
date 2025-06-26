import Foundation
import SwiftData

@Model
final class HealthRecord {
    var id: UUID
    var date: Date
    var weight: Double
    var height: Double
    var age: Int
    var gender: Gender
    var measurementSystem: MeasurementSystem
    
    var bmi: Double
    var bmiCategory: BMICategory
    var bmr: Double
    var idealWeight: Double
    var bodyFatPercentage: Double
    
    init(weight: Double, height: Double, age: Int, gender: Gender, measurementSystem: MeasurementSystem) {
        self.id = UUID()
        self.date = Date()
        self.weight = weight
        self.height = height
        self.age = age
        self.gender = gender
        self.measurementSystem = measurementSystem
        
        let calculator = HealthCalculator()
        self.bmi = calculator.calculateBMI(weight: weight, height: height, isMetric: measurementSystem == .metric)
        self.bmiCategory = calculator.getBMICategory(bmi: self.bmi)
        self.bmr = calculator.calculateBMR(weight: weight, height: height, age: age, gender: gender, isMetric: measurementSystem == .metric)
        self.idealWeight = calculator.calculateIdealWeight(height: height, gender: gender, isMetric: measurementSystem == .metric)
        self.bodyFatPercentage = calculator.calculateBodyFat(bmi: self.bmi, age: age, gender: gender)
    }
}

@Model
final class UserProfile {
    var id: UUID
    var name: String
    var dateOfBirth: Date
    var gender: Gender
    var preferredUnits: MeasurementSystem
    var goalWeight: Double?
    var activityLevel: ActivityLevel
    
    init(name: String, dateOfBirth: Date, gender: Gender, preferredUnits: MeasurementSystem = .metric, activityLevel: ActivityLevel = .moderate) {
        self.id = UUID()
        self.name = name
        self.dateOfBirth = dateOfBirth
        self.gender = gender
        self.preferredUnits = preferredUnits
        self.activityLevel = activityLevel
    }
    
    var age: Int {
        Calendar.current.dateComponents([.year], from: dateOfBirth, to: Date()).year ?? 0
    }
}

enum Gender: String, Codable, CaseIterable {
    case male = "male"
    case female = "female"
    case other = "other"
    
    var name: String {
        switch self {
        case .male: return "Male"
        case .female: return "Female"
        case .other: return "Other"
        }
    }
}

enum ActivityLevel: String, Codable, CaseIterable {
    case sedentary = "sedentary"
    case light = "light"
    case moderate = "moderate"
    case active = "active"
    case veryActive = "veryActive"
    
    var name: String {
        switch self {
        case .sedentary: return "Sedentary"
        case .light: return "Lightly Active"
        case .moderate: return "Moderately Active"
        case .active: return "Active"
        case .veryActive: return "Very Active"
        }
    }
    
    var multiplier: Double {
        switch self {
        case .sedentary: return 1.2
        case .light: return 1.375
        case .moderate: return 1.55
        case .active: return 1.725
        case .veryActive: return 1.9
        }
    }
}