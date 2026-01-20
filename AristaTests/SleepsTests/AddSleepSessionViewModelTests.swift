import XCTest
import CoreData
@testable import Arista

final class AddSleepSessionViewModelTests: XCTestCase {
    
    var persistenceController: PersistenceController!
    var viewModel: AddSleepSessionViewModel!
    
    override func setUpWithError() throws {
        persistenceController = PersistenceController(inMemory: true)
        
        // Nettoyer TOUTES les entités (Sleep ET User)
        emptyAllEntities(context: persistenceController.container.viewContext)
        
        // Créer un utilisateur pour les tests (requis par SleepRepository)
        let user = User(context: persistenceController.container.viewContext)
        user.firstName = "Test"
        user.lastName = "User"
        try persistenceController.container.viewContext.save()
        
        let repository = SleepRepository(viewContext: persistenceController.container.viewContext)
        viewModel = AddSleepSessionViewModel(sleepRepository: repository)
    }
    
    override func tearDownWithError() throws {
        emptyAllEntities(context: persistenceController.container.viewContext)
        viewModel = nil
        persistenceController = nil
    }
    
    // MARK: - Tests
    
    func test_WhenAddingSleepSession_SessionIsSavedInDatabase() throws {
        // Given
        viewModel.duration = 480
        viewModel.quality = 4
        let startDate = Date()
        viewModel.startTime = startDate
        
        // When
        viewModel.addSleepSession()
        
        // Then
        let fetchRequest: NSFetchRequest<Sleep> = Sleep.fetchRequest()
        let sleepSessions = try persistenceController.container.viewContext.fetch(fetchRequest)
        
        XCTAssertEqual(sleepSessions.count, 1, "Should have exactly 1 sleep session")
        XCTAssertEqual(sleepSessions.first?.duration, 480)
        XCTAssertEqual(sleepSessions.first?.quality, 4)
        
        // Vérifier la date avec unwrapping
        if let savedDate = sleepSessions.first?.startDate {
            XCTAssertEqual(savedDate.timeIntervalSince1970, startDate.timeIntervalSince1970, accuracy: 1.0)
        } else {
            XCTFail("startDate should not be nil")
        }
    }
    
    func test_WhenAddingMultipleSleepSessions_AllSessionsAreSaved() throws {
        // Given & When
        viewModel.duration = 420
        viewModel.quality = 3
        viewModel.startTime = Date()
        viewModel.addSleepSession()
        
        viewModel.duration = 480
        viewModel.quality = 5
        viewModel.startTime = Date()
        viewModel.addSleepSession()
        
        // Then
        let fetchRequest: NSFetchRequest<Sleep> = Sleep.fetchRequest()
        let sleepSessions = try persistenceController.container.viewContext.fetch(fetchRequest)
        
        XCTAssertEqual(sleepSessions.count, 2, "Should have exactly 2 sleep sessions")
        
        let durations = sleepSessions.map { $0.duration }.sorted()
        XCTAssertEqual(durations, [420, 480])
    }
    
    func test_WhenDurationIsZero_SessionIsStillSaved() throws {
        // Given
        viewModel.duration = 0
        viewModel.quality = 2
        viewModel.startTime = Date()
        
        // When
        viewModel.addSleepSession()
        
        // Then
        let fetchRequest: NSFetchRequest<Sleep> = Sleep.fetchRequest()
        let sleepSessions = try persistenceController.container.viewContext.fetch(fetchRequest)
        
        XCTAssertEqual(sleepSessions.count, 1, "Should have exactly 1 sleep session")
        XCTAssertEqual(sleepSessions.first?.duration, 0)
    }
    
    func test_WhenInitialized_PropertiesHaveDefaultValues() {
        // Then
        XCTAssertEqual(viewModel.duration, 0)
        XCTAssertEqual(viewModel.quality, 0)
        XCTAssertNotNil(viewModel.startTime)
    }
    
    // MARK: - Helper Methods
    
    private func emptyAllEntities(context: NSManagedObjectContext) {
        // Nettoyer les Sleep
        let sleepFetchRequest = Sleep.fetchRequest()
        let sleeps = try! context.fetch(sleepFetchRequest)
        for sleep in sleeps {
            context.delete(sleep)
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
