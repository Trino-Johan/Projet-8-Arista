import Foundation
import CoreData

final class AddSleepSessionViewModel: ObservableObject {
    @Published var startTime: Date = Date()
    @Published var duration: Int = 0
    @Published var quality: Int = 0

    private let sleepRepository: SleepRepository

    init(sleepRepository: SleepRepository = SleepRepository()) {
        self.sleepRepository = sleepRepository
    }

    func addSleepSession() {
        do {
            try sleepRepository.addSleepSession(
                startDate: startTime,
                duration: duration,
                quality: quality
            )
        } catch {
            print("Error when trying to add sleep session: \(error)")
        }
    }
}
