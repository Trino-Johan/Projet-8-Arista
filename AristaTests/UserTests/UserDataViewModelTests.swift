import XCTest
import CoreData
@testable import Arista

final class UserDataViewModelTests: XCTestCase {
    
    var persistenceController: PersistenceController!
    
    override func setUpWithError() throws {
        persistenceController = PersistenceController(inMemory: true)
        emptyAllEntities(context: persistenceController.container.viewContext)
    }
    
    override func tearDownWithError() throws {
        emptyAllEntities(context: persistenceController.container.viewContext)
        persistenceController = nil
    }
    
    // MARK: - Tests
    
    func test_WhenUserExists_FetchUserData_LoadsFirstNameAndLastName() throws {
        // Given
        let user = User(context: persistenceController.container.viewContext)
        user.firstName = "Eric"
        user.lastName = "Dupont"
        try persistenceController.container.viewContext.save()
        
        let repository = UserRepository(viewContext: persistenceController.container.viewContext)
        
        // When
        let viewModel = UserDataViewModel(userRepository: repository)
        
        // Then
        let expectation = XCTestExpectation(description: "fetch user data")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertEqual(viewModel.firstName, "Eric")
            XCTAssertEqual(viewModel.lastName, "Dupont")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1)
    }
    
    func test_WhenUserHasEmptyFirstName_FetchUserData_LoadsEmptyString() throws {
        // Given
        let user = User(context: persistenceController.container.viewContext)
        user.firstName = ""
        user.lastName = "Martin"
        try persistenceController.container.viewContext.save()
        
        let repository = UserRepository(viewContext: persistenceController.container.viewContext)
        
        // When
        let viewModel = UserDataViewModel(userRepository: repository)
        
        // Then
        let expectation = XCTestExpectation(description: "fetch user with empty first name")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertEqual(viewModel.firstName, "")
            XCTAssertEqual(viewModel.lastName, "Martin")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1)
    }
    
    func test_WhenUserHasNilNames_FetchUserData_LoadsEmptyStrings() throws {
        // Given
        let user = User(context: persistenceController.container.viewContext)
        user.firstName = nil
        user.lastName = nil
        try persistenceController.container.viewContext.save()
        
        let repository = UserRepository(viewContext: persistenceController.container.viewContext)
        
        // When
        let viewModel = UserDataViewModel(userRepository: repository)
        
        // Then
        let expectation = XCTestExpectation(description: "fetch user with nil names")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertEqual(viewModel.firstName, "")
            XCTAssertEqual(viewModel.lastName, "")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1)
    }
    
    func test_WhenInitialized_PropertiesAreEmpty() {
        // Given
        let repository = UserRepository(viewContext: persistenceController.container.viewContext)
        
        // When - On crée le ViewModel sans utilisateur dans la base
        

    }
    
    // MARK: - Helper Methods
    
    private func emptyAllEntities(context: NSManagedObjectContext) {
        // Nettoyer les Sleep
        let sleepFetchRequest = Sleep.fetchRequest()
        let sleeps = try! context.fetch(sleepFetchRequest)
        for sleep in sleeps {
            context.delete(sleep)
        }
        
        // Nettoyer les Exercise
        let exerciseFetchRequest = Exercise.fetchRequest()
        let exercises = try! context.fetch(exerciseFetchRequest)
        for exercise in exercises {
            context.delete(exercise)
        }
        
        // Nettoyer les User
        let userFetchRequest = User.fetchRequest()
        let users = try! context.fetch(userFetchRequest)
        for user in users {
            context.delete(user)
        }
        
        try! context.save()
    }
}

