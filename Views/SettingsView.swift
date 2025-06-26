import SwiftUI
import SwiftData

struct SettingsView: View {
    @AppStorage("preferredUnits") private var preferredUnits: MeasurementSystem = .metric
    @AppStorage("colorScheme") private var colorScheme: ColorSchemeOption = .system
    @AppStorage("enableHaptics") private var enableHaptics = true
    @AppStorage("enableNotifications") private var enableNotifications = false
    @AppStorage("showTips") private var showTips = true
    
    @Environment(\.modelContext) private var modelContext
    @Query private var userProfiles: [UserProfile]
    
    @State private var showingProfileSheet = false
    @State private var showingDataExport = false
    @State private var showingAbout = false
    
    var currentProfile: UserProfile? {
        userProfiles.first
    }
    
    var body: some View {
        NavigationStack {
            Form {
                profileSection
                
                preferencesSection
                
                dataSection
                
                aboutSection
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.large)
            .sheet(isPresented: $showingProfileSheet) {
                ProfileEditView(profile: currentProfile)
            }
            .sheet(isPresented: $showingDataExport) {
                DataExportView()
            }
            .sheet(isPresented: $showingAbout) {
                AboutView()
            }
        }
    }
    
    private var profileSection: some View {
        Section("Profile") {
            HStack {
                Image(systemName: "person.circle.fill")
                    .font(.title2)
                    .foregroundStyle(.accent)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(currentProfile?.name ?? "Add Profile")
                        .font(.headline)
                    if let profile = currentProfile {
                        Text("\(profile.age) years old • \(profile.gender.name)")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
                
                Spacer()
                
                Button(currentProfile == nil ? "Create" : "Edit") {
                    showingProfileSheet = true
                }
                .font(.subheadline)
                .foregroundStyle(.accent)
            }
            .contentShape(Rectangle())
            .onTapGesture {
                showingProfileSheet = true
            }
        }
    }
    
    private var preferencesSection: some View {
        Section("Preferences") {
            Picker("Units", selection: $preferredUnits) {
                ForEach(MeasurementSystem.allCases, id: \.self) { system in
                    Text(system.name).tag(system)
                }
            }
            .pickerStyle(.menu)
            
            Picker("Appearance", selection: $colorScheme) {
                ForEach(ColorSchemeOption.allCases, id: \.self) { scheme in
                    Text(scheme.name).tag(scheme)
                }
            }
            .pickerStyle(.menu)
            
            Toggle("Haptic Feedback", isOn: $enableHaptics)
            
            Toggle("Show Tips", isOn: $showTips)
            
            HStack {
                Text("Notifications")
                Spacer()
                Toggle("", isOn: $enableNotifications)
                    .labelsHidden()
            }
            .foregroundStyle(enableNotifications ? .primary : .secondary)
        }
    }
    
    private var dataSection: some View {
        Section("Data") {
            Button("Export Data") {
                showingDataExport = true
            }
            .foregroundStyle(.accent)
            
            Button("Reset All Data") {
                resetAllData()
            }
            .foregroundStyle(.red)
        }
    }
    
    private var aboutSection: some View {
        Section("About") {
            HStack {
                Text("Version")
                Spacer()
                Text("1.0.0")
                    .foregroundStyle(.secondary)
            }
            
            Button("About HealthPulse") {
                showingAbout = true
            }
            .foregroundStyle(.accent)
            
            Link("Privacy Policy", destination: URL(string: "https://example.com/privacy")!)
                .foregroundStyle(.accent)
            
            Link("Terms of Service", destination: URL(string: "https://example.com/terms")!)
                .foregroundStyle(.accent)
        }
    }
    
    private func resetAllData() {
        // Delete all health records
        for record in try! modelContext.fetch(FetchDescriptor<HealthRecord>()) {
            modelContext.delete(record)
        }
        
        // Delete all user profiles
        for profile in userProfiles {
            modelContext.delete(profile)
        }
        
        try? modelContext.save()
        
        // Reset user defaults
        preferredUnits = .metric
        colorScheme = .system
        enableHaptics = true
        enableNotifications = false
        showTips = true
    }
}

struct ProfileEditView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    
    let profile: UserProfile?
    
    @State private var name: String = ""
    @State private var dateOfBirth = Date()
    @State private var gender: Gender = .male
    @State private var preferredUnits: MeasurementSystem = .metric
    @State private var activityLevel: ActivityLevel = .moderate
    @State private var goalWeight: String = ""
    
    var isEditing: Bool {
        profile != nil
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Basic Information") {
                    TextField("Name", text: $name)
                    
                    DatePicker("Date of Birth", selection: $dateOfBirth, displayedComponents: .date)
                        .datePickerStyle(.compact)
                    
                    Picker("Gender", selection: $gender) {
                        ForEach(Gender.allCases, id: \.self) { gender in
                            Text(gender.name).tag(gender)
                        }
                    }
                    .pickerStyle(.menu)
                }
                
                Section("Preferences") {
                    Picker("Preferred Units", selection: $preferredUnits) {
                        ForEach(MeasurementSystem.allCases, id: \.self) { system in
                            Text(system.name).tag(system)
                        }
                    }
                    .pickerStyle(.menu)
                    
                    Picker("Activity Level", selection: $activityLevel) {
                        ForEach(ActivityLevel.allCases, id: \.self) { level in
                            Text(level.name).tag(level)
                        }
                    }
                    .pickerStyle(.menu)
                }
                
                Section("Goals") {
                    TextField("Goal Weight (optional)", text: $goalWeight)
                        .keyboardType(.decimalPad)
                }
            }
            .navigationTitle(isEditing ? "Edit Profile" : "Create Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveProfile()
                    }
                    .disabled(name.isEmpty)
                }
            }
            .onAppear {
                if let profile = profile {
                    name = profile.name
                    dateOfBirth = profile.dateOfBirth
                    gender = profile.gender
                    preferredUnits = profile.preferredUnits
                    activityLevel = profile.activityLevel
                    goalWeight = profile.goalWeight.map { String($0) } ?? ""
                }
            }
        }
    }
    
    private func saveProfile() {
        if let existingProfile = profile {
            existingProfile.name = name
            existingProfile.dateOfBirth = dateOfBirth
            existingProfile.gender = gender
            existingProfile.preferredUnits = preferredUnits
            existingProfile.activityLevel = activityLevel
            existingProfile.goalWeight = Double(goalWeight)
        } else {
            let newProfile = UserProfile(
                name: name,
                dateOfBirth: dateOfBirth,
                gender: gender,
                preferredUnits: preferredUnits,
                activityLevel: activityLevel
            )
            newProfile.goalWeight = Double(goalWeight)
            modelContext.insert(newProfile)
        }
        
        try? modelContext.save()
        dismiss()
    }
}

struct DataExportView: View {
    @Environment(\.dismiss) private var dismiss
    @Query private var healthRecords: [HealthRecord]
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Image(systemName: "square.and.arrow.up.circle.fill")
                    .font(.system(size: 80))
                    .foregroundStyle(.accent)
                
                Text("Export Your Data")
                    .font(.title2)
                    .fontWeight(.semibold)
                
                Text("Export all your health records as a CSV file.")
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.secondary)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Export includes:")
                        .font(.headline)
                    
                    Label("All BMI calculations", systemImage: "checkmark.circle.fill")
                    Label("Weight and height records", systemImage: "checkmark.circle.fill")
                    Label("Timestamps and dates", systemImage: "checkmark.circle.fill")
                    Label("Health metrics", systemImage: "checkmark.circle.fill")
                }
                .foregroundStyle(.secondary)
                
                Spacer()
                
                ShareLink(
                    item: generateCSVData(),
                    preview: SharePreview("Health Data Export", image: "chart.line.uptrend.xyaxis")
                ) {
                    Text("Export Data")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.accent)
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
            }
            .padding()
            .navigationTitle("Export Data")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    private func generateCSVData() -> String {
        var csv = "Date,Weight,Height,Age,Gender,BMI,Category,BMR,Ideal Weight,Body Fat\n"
        
        for record in healthRecords.sorted(by: { $0.date < $1.date }) {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .short
            dateFormatter.timeStyle = .short
            
            csv += "\(dateFormatter.string(from: record.date)),"
            csv += "\(record.weight),"
            csv += "\(record.height),"
            csv += "\(record.age),"
            csv += "\(record.gender.name),"
            csv += "\(String(format: "%.1f", record.bmi)),"
            csv += "\(record.bmiCategory.name),"
            csv += "\(String(format: "%.0f", record.bmr)),"
            csv += "\(String(format: "%.1f", record.idealWeight)),"
            csv += "\(String(format: "%.1f", record.bodyFatPercentage))\n"
        }
        
        return csv
    }
}

struct AboutView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    Image(systemName: "heart.text.square.fill")
                        .font(.system(size: 80))
                        .foregroundStyle(.accent)
                    
                    VStack(spacing: 8) {
                        Text("HealthPulse")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        
                        Text("Version 1.0.0")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    
                    Text("A modern health tracking app built with SwiftUI and iOS 17 features. Calculate your BMI, track your health metrics, and monitor your progress over time.")
                        .multilineTextAlignment(.center)
                        .foregroundStyle(.secondary)
                    
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Features")
                            .font(.headline)
                        
                        FeatureRow(icon: "heart.fill", title: "BMI Calculator", description: "Calculate your Body Mass Index with accurate formulas")
                        FeatureRow(icon: "chart.line.uptrend.xyaxis", title: "Health Trends", description: "Visualize your health progress with interactive charts")
                        FeatureRow(icon: "flame.fill", title: "Metabolic Rate", description: "Calculate BMR and daily calorie needs")
                        FeatureRow(icon: "target", title: "Health Goals", description: "Track your ideal weight and body composition")
                    }
                    
                    Spacer()
                }
                .padding()
            }
            .navigationTitle("About")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct FeatureRow: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(.accent)
                .frame(width: 30)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.headline)
                
                Text(description)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
        }
    }
}

#Preview {
    SettingsView()
        .modelContainer(for: [HealthRecord.self, UserProfile.self], inMemory: true)
}