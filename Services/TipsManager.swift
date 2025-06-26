import Foundation
import TipKit

class TipsManager {
    static let shared = TipsManager()
    
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