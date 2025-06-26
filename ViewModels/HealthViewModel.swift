import SwiftUI
import SwiftData
import Observation

@Observable
final class HealthViewModel {
    var weight: String = ""
    var height: String = ""
    var age: String = ""
    var gender: Gender = .male
    var measurementSystem: MeasurementSystem = .metric
    
    var currentBMI: Double = 0
    var currentCategory: BMICategory = .normal
    var currentBMR: Double = 0
    var currentIdealWeight: Double = 0
    var currentBodyFat: Double = 0
    var currentTDEE: Double = 0
    
    var showResults: Bool = false
    var isCalculating: Bool = false
    var showValidationError: Bool = false
    var validationMessage: String = ""
    
    private let calculator = HealthCalculator()
    
    var weightValue: Double? {
        Double(weight)
    }
    
    var heightValue: Double? {
        Double(height)
    }
    
    var ageValue: Int? {
        Int(age)
    }
    
    var isValidInput: Bool {
        guard let w = weightValue, let h = heightValue, let a = ageValue else {
            return false
        }
        
        if measurementSystem == .metric {
            return w >= 10 && w <= 500 && h >= 50 && h <= 300 && a >= 1 && a <= 120
        } else {
            return w >= 22 && w <= 1100 && h >= 20 && h <= 120 && a >= 1 && a <= 120
        }
    }
    
    var weightPlaceholder: String {
        measurementSystem == .metric ? "Weight (kg)" : "Weight (lbs)"
    }
    
    var heightPlaceholder: String {
        measurementSystem == .metric ? "Height (cm)" : "Height (inches)"
    }
    
    var weightRange: String {
        measurementSystem == .metric ? "10-500 kg" : "22-1100 lbs"
    }
    
    var heightRange: String {
        measurementSystem == .metric ? "50-300 cm" : "20-120 inches"
    }
    
    func calculate() {
        guard isValidInput,
              let w = weightValue,
              let h = heightValue,
              let a = ageValue else {
            showValidationError = true
            validationMessage = "Please enter valid values"
            return
        }
        
        isCalculating = true
        
        Task { @MainActor in
            try? await Task.sleep(nanoseconds: 500_000_000)
            
            currentBMI = calculator.calculateBMI(weight: w, height: h, isMetric: measurementSystem == .metric)
            currentCategory = calculator.getBMICategory(bmi: currentBMI)
            currentBMR = calculator.calculateBMR(weight: w, height: h, age: a, gender: gender, isMetric: measurementSystem == .metric)
            currentIdealWeight = calculator.calculateIdealWeight(height: h, gender: gender, isMetric: measurementSystem == .metric)
            currentBodyFat = calculator.calculateBodyFat(bmi: currentBMI, age: a, gender: gender)
            currentTDEE = calculator.calculateTDEE(bmr: currentBMR, activityLevel: .moderate)
            
            isCalculating = false
            showResults = true
        }
    }
    
    func saveRecord(to modelContext: ModelContext) {
        guard let w = weightValue,
              let h = heightValue,
              let a = ageValue else { return }
        
        let record = HealthRecord(
            weight: w,
            height: h,
            age: a,
            gender: gender,
            measurementSystem: measurementSystem
        )
        
        modelContext.insert(record)
        
        do {
            try modelContext.save()
        } catch {
            print("Failed to save record: \(error)")
        }
    }
    
    func reset() {
        weight = ""
        height = ""
        age = ""
        gender = .male
        currentBMI = 0
        showResults = false
        showValidationError = false
    }
    
    func formatWeight(_ weight: Double, isMetric: Bool) -> String {
        return calculator.formatWeight(weight, isMetric: isMetric)
    }
}