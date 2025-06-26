# HealthPulse 🫀

A modern iOS health assessment app built with SwiftUI and iOS 17+ features. Calculate your BMI, track health metrics, and monitor your progress over time with beautiful animations and comprehensive health insights.

## ✨ Features

### Core Health Calculations
- **BMI (Body Mass Index)** - WHO-approved calculation formulas
- **BMR (Basal Metabolic Rate)** - Harris-Benedict equation
- **TDEE (Total Daily Energy Expenditure)** - Activity-adjusted calories
- **Ideal Body Weight** - D.R. Miller formula
- **Body Fat Percentage** - Deurenberg estimation

### Modern iOS 17+ Features
- **SwiftData** - Persistent health record storage
- **Swift Charts** - Interactive health trend visualization
- **TipKit Integration** - Contextual user guidance
- **Phase Animator** - Smooth multi-step animations
- **Keyframe Animator** - Complex animation sequences
- **Symbol Effects** - Animated SF Symbols
- **App Intents** - Siri Shortcuts support
- **Widgets** - Home screen health overview

### User Experience
- **Color-coded Health Status** - Visual BMI category indicators
- **Dark Mode Support** - Automatic theme switching
- **Metric/Imperial Units** - Flexible measurement systems
- **Data Export** - CSV export for health records
- **Haptic Feedback** - Enhanced tactile interactions
- **Accessibility** - VoiceOver and Dynamic Type support

## 🎨 Design System

### Color Palette
- **Underweight**: Light Blue (`#5AC8FA`)
- **Normal**: Green (`#34C759`)
- **Overweight**: Orange (`#FF9500`)
- **Obese**: Red (`#FF3B30`)
- **Primary**: System Blue (`#007AFF`)

### Typography
- San Francisco (System Font)
- Dynamic Type support
- Rounded variants for metrics

### Animations
- Spring animations for natural feel
- Phase transitions for multi-state changes
- Keyframe sequences for complex motions
- Haptic feedback integration

## 🏗️ Architecture

### Project Structure
```
HealthPulse/
├── App/
│   ├── HealthPulseApp.swift          # Main app entry point
│   └── AppIntents.swift              # Siri Shortcuts
├── Views/
│   ├── ContentView.swift             # Tab view controller
│   ├── InputView.swift               # Health data input
│   ├── ResultsView.swift             # Calculation results
│   ├── HistoryView.swift             # Health trends & charts
│   └── SettingsView.swift            # User preferences
├── ViewModels/
│   └── HealthViewModel.swift         # @Observable view model
├── Models/
│   ├── HealthRecord.swift            # SwiftData models
│   └── BMICategory.swift             # Health categories
├── Services/
│   ├── HealthCalculator.swift        # Calculation engine
│   └── TipsProvider.swift            # TipKit configuration
├── Components/
│   └── AnimatedHealthIndicator.swift # Custom animations
└── Widgets/
    └── HealthWidget.swift            # Home screen widgets
```

### Tech Stack
- **Language**: Swift 5.9+
- **UI Framework**: SwiftUI (iOS 17+)
- **Data**: SwiftData for persistence
- **Charts**: Swift Charts
- **Architecture**: MVVM with @Observable
- **Dependencies**: Native iOS frameworks only

## 📱 Screenshots

*Add screenshots here showing:*
- Input screen with TipKit
- Animated results with color coding
- Health trends charts
- Settings and profile management
- Widget on home screen

## 🚀 Getting Started

### Requirements
- Xcode 15.0+
- iOS 17.0+ deployment target
- iPhone, iPad, and Apple Watch support
- macOS 13.0+ (for development)

### Development Setup in Xcode

#### 1. Project Setup
```bash
# Clone or download the project
git clone https://github.com/yourusername/healthpulse.git
cd HealthPulse
```

#### 2. Open Project in Xcode
```bash
# Open the Xcode project file
open HealthPulse.xcodeproj
```

#### 3. Configure Project Settings
1. **Select the HealthPulse target** in the project navigator
2. **General Tab**:
   - Bundle Identifier: `com.healthpulse.app` (or customize)
   - Deployment Target: iOS 17.0
   - Supported Destinations: iPhone, iPad
3. **Signing & Capabilities**:
   - Select your development team
   - Enable automatic signing for development
4. **Build Settings**:
   - Swift Language Version: Swift 5
   - Build Configuration: Debug (for development)

#### 4. Dependencies & Frameworks
The project uses only native iOS frameworks:
- **SwiftUI** - UI framework
- **SwiftData** - Data persistence
- **TipKit** - User guidance
- **Charts** - Data visualization
- **WidgetKit** - Home screen widgets
- **AppIntents** - Siri integration

*No external dependencies or package managers required!*

#### 5. Build and Run
1. **Select target device**:
   - iPhone 15 Simulator (recommended)
   - Physical iPhone (iOS 17.0+)
   - iPad Simulator
   
2. **Build the project**:
   ```
   Product → Build (⌘+B)
   ```

3. **Run on simulator/device**:
   ```
   Product → Run (⌘+R)
   ```

#### 6. Development Workflow
1. **Code Structure**: Follow the MVVM architecture
2. **SwiftUI Previews**: Use for rapid UI development
3. **Live Preview**: Enable for real-time updates
4. **Simulator**: Test different device sizes and orientations

### First Launch
1. The app will display input tips on first launch
2. Enter your weight, height, age, and gender
3. Toggle between metric and imperial units
4. Tap "Calculate Health Metrics" to see results
5. Results are automatically saved to history

## 🔧 Configuration

### TipKit Setup
Tips are automatically configured on app launch. To reset tips during development:
```swift
TipsManager.shared.resetTips()
```

### Widget Configuration
1. Add the HealthPulse widget to your home screen
2. Choose between small and medium sizes
3. Widget updates automatically with new calculations

### Siri Shortcuts
Available voice commands:
- "Calculate my BMI with HealthPulse"
- "What was my last BMI"
- "Show my recent health data"

## 📊 Health Calculations

### BMI Formula
```swift
// Metric: BMI = weight(kg) / height(m)²
// Imperial: BMI = (weight(lbs) / height(in)²) × 703
```

### BMI Categories (WHO Standard)
- **Underweight**: BMI < 18.5
- **Normal**: BMI 18.5-24.9
- **Overweight**: BMI 25.0-29.9
- **Obese**: BMI ≥ 30.0

### BMR Calculation (Harris-Benedict)
- **Men**: BMR = 88.362 + (13.397 × weight) + (4.799 × height) - (5.677 × age)
- **Women**: BMR = 447.593 + (9.247 × weight) + (3.098 × height) - (4.330 × age)

## 🧪 Testing & Debugging in Xcode

### Running Tests
1. **Unit Tests**:
   ```
   Product → Test (⌘+U)
   ```
   Or via command line:
   ```bash
   xcodebuild test -scheme HealthPulse -destination 'platform=iOS Simulator,name=iPhone 15'
   ```

2. **UI Tests**:
   - Navigate to Test Navigator (⌘+6)
   - Run individual test classes or methods
   - Use Test Plan for comprehensive testing

### Debugging Tools
1. **Xcode Debugger**:
   - Set breakpoints in code
   - Use `po` command in console
   - Inspect view hierarchy
   
2. **SwiftUI Previews**:
   - Real-time UI updates
   - Multiple device previews
   - Dark mode testing
   
3. **Instruments**:
   - Profile performance
   - Monitor memory usage
   - Analyze network activity

### Common Development Tasks
1. **Adding New Views**:
   - Create SwiftUI view files in `/Views/`
   - Add to Xcode project
   - Include in navigation structure

2. **Modifying Health Calculations**:
   - Edit `HealthCalculator.swift`
   - Update unit tests
   - Verify accuracy with known values

3. **SwiftData Model Changes**:
   - Update model in `HealthRecord.swift`
   - Handle data migration if needed
   - Test with existing data

### Build Configurations
- **Debug**: Development with debugging symbols
- **Release**: App Store distribution
- **Testing**: Unit test configuration

### Troubleshooting
1. **Build Errors**:
   - Clean build folder: `Product → Clean Build Folder (⇧⌘K)`
   - Reset simulator: `Device → Erase All Content and Settings`
   
2. **SwiftData Issues**:
   - Check model container setup
   - Verify data model relationships
   - Clear app data in simulator

3. **Preview Issues**:
   - Restart Xcode
   - Clear derived data
   - Check preview provider implementation

## 🔒 Privacy & Security

### Data Handling
- All health data stored locally with SwiftData
- No data transmitted to external servers
- User consent for HealthKit integration (optional)
- Data export in standard CSV format

### Privacy Features
- No analytics or tracking
- No user accounts required
- Offline-first design
- Full user control over data deletion

## 🤝 Contributing

### Development Setup in Xcode
1. **Fork the repository** on GitHub
2. **Clone your fork locally**:
   ```bash
   git clone https://github.com/yourusername/healthpulse.git
   cd HealthPulse
   ```
3. **Open in Xcode**: `open HealthPulse.xcodeproj`
4. **Create a feature branch**:
   ```bash
   git checkout -b feature/amazing-feature
   ```
5. **Set up development environment**:
   - Configure signing with your Apple Developer account
   - Enable SwiftUI previews for faster development
   - Set up simulator for testing

### Code Style & Guidelines
1. **Swift Style**:
   - Use SwiftLint for consistent formatting
   - Follow Apple's Swift style guide
   - Use meaningful variable and function names
   - Add documentation comments for public APIs

2. **SwiftUI Best Practices**:
   - Keep views small and focused
   - Use `@State`, `@Binding`, `@Observable` appropriately
   - Leverage SwiftUI previews for development
   - Follow iOS Human Interface Guidelines

3. **Architecture**:
   - Follow MVVM pattern with `@Observable`
   - Keep business logic in services/calculators
   - Use SwiftData for data persistence
   - Maintain separation of concerns

### Development Workflow
1. **Before coding**:
   - Test the current build works
   - Create feature branch from main
   - Write failing tests for new features

2. **While coding**:
   - Use SwiftUI previews for rapid iteration
   - Test on multiple device sizes
   - Verify dark mode compatibility
   - Add unit tests as you go

3. **Before submitting**:
   - Run all tests: `Product → Test (⌘+U)`
   - Test on physical device
   - Check accessibility with VoiceOver
   - Verify performance with Instruments

### Pull Request Process
1. **Test thoroughly**:
   ```bash
   # Build and test
   xcodebuild clean build test -scheme HealthPulse
   ```
2. **Update documentation** if needed
3. **Write descriptive commit messages**
4. **Submit pull request** with:
   - Clear description of changes
   - Screenshots/videos if UI changes
   - Test plan and results
   - Breaking changes noted

### Adding New Features
1. **Health Calculations**:
   - Add logic to `HealthCalculator.swift`
   - Include unit tests with known values
   - Update result display views
   - Add to export functionality

2. **UI Components**:
   - Create reusable SwiftUI views
   - Add to appropriate folder structure
   - Include SwiftUI previews
   - Test with different data states

3. **Data Models**:
   - Update SwiftData models carefully
   - Consider migration for existing data
   - Update related views and calculations
   - Test data persistence

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Apple for iOS 17 SwiftUI enhancements
- WHO for BMI calculation standards
- Harris-Benedict for BMR formulas
- Design inspiration from Apple Health

## 📞 Support

For support, feature requests, or bug reports:
- Create an issue on GitHub
- Email: support@healthpulse.app
- Twitter: @HealthPulseApp

---

**Built with ❤️ using SwiftUI and iOS 17**