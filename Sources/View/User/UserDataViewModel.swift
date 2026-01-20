import Foundation
import CoreData

final class UserDataViewModel: ObservableObject {
    @Published var firstName: String = ""
    @Published var lastName: String = ""

    private let userRepository: UserRepository

    init(userRepository: UserRepository = UserRepository()) {
        self.userRepository = userRepository
        fetchUserData()
    }

    private func fetchUserData() {
        do {
            guard let user = try userRepository.getUser() else {
                return
            }
            firstName = user.firstName ?? ""
            lastName = user.lastName ?? ""
        } catch {
            print("Error when trying to get user: \(error)")
        }
    }
}
