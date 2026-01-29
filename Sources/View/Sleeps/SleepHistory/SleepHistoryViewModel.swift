import Foundation

final class SleepHistoryViewModel: ObservableObject {
    @Published var sleepSessions = [Sleep]()
    
    let repository: SleepRepository

    init(repository: SleepRepository = SleepRepository()) {
        self.repository = repository
        fetchSleepSessions()
    }

    
    private func fetchSleepSessions() {
       
        do {
            sleepSessions = try repository.getSleepSessions()
        } catch {
            print("Error when trying to get sleep sessions: \(error)")
        }
    }
    
    func reload() {
        fetchSleepSessions()
    }
}
