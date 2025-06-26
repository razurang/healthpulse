import SwiftUI
import TipKit

struct InputView: View {
    @Bindable var viewModel: HealthViewModel
    @Environment(\.modelContext) private var modelContext
    @State private var showingResults = false
    @FocusState private var focusedField: Field?
    
    enum Field {
        case weight, height, age
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    headerSection
                    
                    inputSection
                        .padding(.horizontal)
                    
                    calculateButton
                        .padding(.horizontal)
                    
                    if viewModel.showValidationError {
                        validationErrorView
                    }
                }
                .padding(.vertical)
            }
            .scrollBounceBehavior(.basedOnSize)
            .navigationTitle("Health Calculator")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Reset", systemImage: "arrow.counterclockwise") {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                            viewModel.reset()
                        }
                    }
                    .symbolEffect(.bounce, value: viewModel.showResults)
                }
            }
            .sheet(isPresented: $viewModel.showResults) {
                ResultsView(viewModel: viewModel)
                    .presentationDragIndicator(.visible)
                    .presentationCornerRadius(25)
            }
        }
    }
    
    private var headerSection: some View {
        VStack(spacing: 10) {
            Image(systemName: "heart.text.square.fill")
                .font(.system(size: 60))
                .foregroundStyle(.accent)
                .symbolEffect(.pulse, value: viewModel.isCalculating)
            
            Text("Track Your Health")
                .font(.title2)
                .fontWeight(.semibold)
            
            Text("Enter your details to calculate BMI and health metrics")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
            
            TipView(TipsManager.shared.inputTip) { action in
                if action.id == "learn-more" {
                    // Handle learn more action
                }
            }
        }
        .padding()
    }
    
    private var inputSection: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Units")
                    .font(.headline)
                
                Spacer()
                
                Picker("Units", selection: $viewModel.measurementSystem) {
                    ForEach(MeasurementSystem.allCases, id: \.self) { system in
                        Text(system.name).tag(system)
                    }
                }
                .pickerStyle(.segmented)
                .frame(width: 200)
            }
            .padding(.bottom, 8)
            
            VStack(spacing: 16) {
                InputField(
                    value: $viewModel.weight,
                    placeholder: viewModel.weightPlaceholder,
                    icon: "scalemass.fill",
                    keyboardType: .decimalPad,
                    focused: $focusedField,
                    field: .weight,
                    helperText: viewModel.weightRange
                )
                
                InputField(
                    value: $viewModel.height,
                    placeholder: viewModel.heightPlaceholder,
                    icon: "ruler.fill",
                    keyboardType: .decimalPad,
                    focused: $focusedField,
                    field: .height,
                    helperText: viewModel.heightRange
                )
                
                InputField(
                    value: $viewModel.age,
                    placeholder: "Age (years)",
                    icon: "calendar",
                    keyboardType: .numberPad,
                    focused: $focusedField,
                    field: .age,
                    helperText: "1-120 years"
                )
                
                HStack {
                    Label("Gender", systemImage: "person.fill")
                        .font(.headline)
                    
                    Spacer()
                    
                    Picker("Gender", selection: $viewModel.gender) {
                        ForEach(Gender.allCases, id: \.self) { gender in
                            Text(gender.name).tag(gender)
                        }
                    }
                    .pickerStyle(.menu)
                    .tint(.accent)
                }
                .padding()
                .background(Color(.systemGray6))
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
        }
    }
    
    private var calculateButton: some View {
        Button(action: {
            focusedField = nil
            viewModel.calculate()
            
            if viewModel.isValidInput {
                viewModel.saveRecord(to: modelContext)
            }
        }) {
            HStack {
                if viewModel.isCalculating {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .scaleEffect(0.8)
                } else {
                    Image(systemName: "heart.text.square.fill")
                        .symbolEffect(.bounce.up, value: viewModel.isCalculating)
                }
                
                Text("Calculate Health Metrics")
                    .fontWeight(.semibold)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(viewModel.isValidInput ? Color.accent : Color.gray)
            .foregroundStyle(.white)
            .clipShape(RoundedRectangle(cornerRadius: 15))
        }
        .disabled(!viewModel.isValidInput || viewModel.isCalculating)
        .sensoryFeedback(.impact(flexibility: .soft), trigger: viewModel.showResults)
    }
    
    private var validationErrorView: some View {
        HStack {
            Image(systemName: "exclamationmark.triangle.fill")
                .foregroundStyle(.orange)
            
            Text(viewModel.validationMessage)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding()
        .background(Color.orange.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .padding(.horizontal)
        .transition(.scale.combined(with: .opacity))
    }
}

struct InputField: View {
    @Binding var value: String
    let placeholder: String
    let icon: String
    let keyboardType: UIKeyboardType
    var focused: FocusState<InputView.Field?>.Binding
    let field: InputView.Field
    let helperText: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Image(systemName: icon)
                    .foregroundStyle(.accent)
                    .frame(width: 25)
                
                TextField(placeholder, text: $value)
                    .keyboardType(keyboardType)
                    .focused(focused, equals: field)
                    .textFieldStyle(.plain)
            }
            .padding()
            .background(Color(.systemGray6))
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(focused.wrappedValue == field ? Color.accent : Color.clear, lineWidth: 2)
            )
            
            Text(helperText)
                .font(.caption)
                .foregroundStyle(.secondary)
                .padding(.horizontal, 5)
        }
    }
}

#Preview {
    InputView(viewModel: HealthViewModel())
        .modelContainer(for: [HealthRecord.self, UserProfile.self], inMemory: true)
}