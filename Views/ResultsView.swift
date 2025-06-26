import SwiftUI

struct ResultsView: View {
    @Bindable var viewModel: HealthViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var animateValues = false
    @State private var showDetails = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    bmiResultCard
                        .padding(.top)
                    
                    metricsGrid
                    
                    healthTipCard
                    
                    actionButtons
                }
                .padding()
            }
            .navigationTitle("Your Results")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done", action: { dismiss() })
                        .fontWeight(.semibold)
                }
            }
            .onAppear {
                withAnimation(.spring(response: 0.8, dampingFraction: 0.8)) {
                    animateValues = true
                }
            }
        }
    }
    
    private var bmiResultCard: some View {
        VStack(spacing: 20) {
            Text("Your BMI")
                .font(.headline)
                .foregroundStyle(.secondary)
            
            ZStack {
                CircularProgressView(
                    progress: animateValues ? normalizedBMI : 0,
                    category: viewModel.currentCategory,
                    bmi: viewModel.currentBMI
                )
                .frame(width: 200, height: 200)
                
                VStack(spacing: 8) {
                    Text(String(format: "%.1f", viewModel.currentBMI))
                        .font(.system(size: 48, weight: .bold, design: .rounded))
                        .contentTransition(.numericText())
                    
                    Text(viewModel.currentCategory.name)
                        .font(.headline)
                        .foregroundStyle(viewModel.currentCategory.color)
                }
            }
            
            HStack {
                Image(systemName: viewModel.currentCategory.icon)
                    .foregroundStyle(viewModel.currentCategory.color)
                    .symbolEffect(.bounce, value: animateValues)
                
                Text(viewModel.currentCategory.range)
                    .font(.subheadline)
                    .fontWeight(.medium)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(viewModel.currentCategory.color.opacity(0.1))
            .clipShape(Capsule())
        }
        .padding()
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: .black.opacity(0.05), radius: 10)
    }
    
    private var metricsGrid: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
            MetricCard(
                title: "BMR",
                value: String(format: "%.0f", viewModel.currentBMR),
                unit: "cal/day",
                icon: "flame.fill",
                color: .orange,
                description: "Basal Metabolic Rate"
            )
            .phaseAnimator([false, true], trigger: animateValues) { content, phase in
                content
                    .scaleEffect(phase ? 1 : 0.8)
                    .opacity(phase ? 1 : 0)
            }
            
            MetricCard(
                title: "TDEE",
                value: String(format: "%.0f", viewModel.currentTDEE),
                unit: "cal/day",
                icon: "figure.run",
                color: .green,
                description: "Total Daily Energy"
            )
            .phaseAnimator([false, true], trigger: animateValues) { content, phase in
                content
                    .scaleEffect(phase ? 1 : 0.8)
                    .opacity(phase ? 1 : 0)
            } animation: { phase in
                .spring(response: 0.6, dampingFraction: 0.8).delay(0.1)
            }
            
            MetricCard(
                title: "Ideal Weight",
                value: viewModel.calculator.formatWeight(viewModel.currentIdealWeight, isMetric: viewModel.measurementSystem == .metric),
                unit: "",
                icon: "target",
                color: .blue,
                description: "Target Range"
            )
            .phaseAnimator([false, true], trigger: animateValues) { content, phase in
                content
                    .scaleEffect(phase ? 1 : 0.8)
                    .opacity(phase ? 1 : 0)
            } animation: { phase in
                .spring(response: 0.6, dampingFraction: 0.8).delay(0.2)
            }
            
            MetricCard(
                title: "Body Fat",
                value: String(format: "%.1f", viewModel.currentBodyFat),
                unit: "%",
                icon: "percent",
                color: .purple,
                description: "Estimated"
            )
            .phaseAnimator([false, true], trigger: animateValues) { content, phase in
                content
                    .scaleEffect(phase ? 1 : 0.8)
                    .opacity(phase ? 1 : 0)
            } animation: { phase in
                .spring(response: 0.6, dampingFraction: 0.8).delay(0.3)
            }
        }
    }
    
    private var healthTipCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "lightbulb.fill")
                    .foregroundStyle(.yellow)
                    .symbolEffect(.pulse, value: animateValues)
                
                Text("Health Tip")
                    .font(.headline)
            }
            
            Text(viewModel.currentCategory.healthTip)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 15))
    }
    
    private var actionButtons: some View {
        VStack(spacing: 12) {
            Button(action: {
                dismiss()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    viewModel.reset()
                }
            }) {
                Label("Calculate Again", systemImage: "arrow.clockwise")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.accent)
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            
            ShareLink(
                item: shareText,
                preview: SharePreview("My Health Results", image: "heart.text.square.fill")
            ) {
                Label("Share Results", systemImage: "square.and.arrow.up")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(.systemGray5))
                    .foregroundStyle(.primary)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
        }
    }
    
    private var normalizedBMI: Double {
        min(max(viewModel.currentBMI / 40, 0), 1)
    }
    
    private var shareText: String {
        """
        My Health Results:
        BMI: \(String(format: "%.1f", viewModel.currentBMI)) - \(viewModel.currentCategory.name)
        BMR: \(String(format: "%.0f", viewModel.currentBMR)) cal/day
        TDEE: \(String(format: "%.0f", viewModel.currentTDEE)) cal/day
        Ideal Weight: \(viewModel.calculator.formatWeight(viewModel.currentIdealWeight, isMetric: viewModel.measurementSystem == .metric))
        Body Fat: \(String(format: "%.1f", viewModel.currentBodyFat))%
        
        Calculated with HealthPulse
        """
    }
    
    let calculator = HealthCalculator()
}

struct CircularProgressView: View {
    let progress: Double
    let category: BMICategory
    let bmi: Double
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(Color(.systemGray5), lineWidth: 20)
            
            Circle()
                .trim(from: 0, to: progress)
                .stroke(
                    category.gradient,
                    style: StrokeStyle(lineWidth: 20, lineCap: .round)
                )
                .rotationEffect(.degrees(-90))
                .animation(.spring(response: 1.0, dampingFraction: 0.8), value: progress)
        }
    }
}

struct MetricCard: View {
    let title: String
    let value: String
    let unit: String
    let icon: String
    let color: Color
    let description: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: icon)
                    .foregroundStyle(color)
                    .font(.title3)
                
                Spacer()
            }
            
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
            
            HStack(alignment: .lastTextBaseline, spacing: 4) {
                Text(value)
                    .font(.title2)
                    .fontWeight(.bold)
                    .contentTransition(.numericText())
                
                Text(unit)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            Text(description)
                .font(.caption2)
                .foregroundStyle(.tertiary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.05), radius: 5)
    }
}

#Preview {
    ResultsView(viewModel: {
        let vm = HealthViewModel()
        vm.currentBMI = 23.5
        vm.currentCategory = .normal
        vm.currentBMR = 1650
        vm.currentTDEE = 2475
        vm.currentIdealWeight = 70
        vm.currentBodyFat = 18.5
        return vm
    }())
}