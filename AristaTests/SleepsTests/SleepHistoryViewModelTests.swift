import XCTest
import CoreData
@testable import Arista

final class SleepHistoryViewModelTests: XCTestCase {
    
    // MARK: - Tests
    
    func test_WhenNoSleepSessionInDatabase_FetchSleepSessions_ReturnEmptyList() {
        let persistenceController = PersistenceController(inMemory: true)
        let testContext = persistenceController.container.viewContext
        emptyEntities(context: testContext)
        
        let repository = SleepRepository(viewContext: testContext)
        let viewModel = SleepHistoryViewModel(repository: repository)
        
        let expectation = XCTestExpectation(description: "fetch empty list of sleep sessions")
        
        // Attente active
        DispatchQueue.main.async {
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 2)
        XCTAssert(viewModel.sleepSessions.isEmpty)
    }
    
    func test_WhenAddingOneSleepSessionInDatabase_FetchSleepSessions_ReturnAListContainingTheSession() {
        let persistenceController = PersistenceController(inMemory: true)
        let testContext = persistenceController.container.viewContext
        emptyEntities(context: testContext)
        
        let startDate = Date()
        
        addSleepSession(context: testContext,
                       startDate: startDate,
                       duration: 480,
                       quality: 4,
                       userFirstName: "Eric",
                       userLastName: "Marcus")
        
        let repository = SleepRepository(viewContext: testContext)
        let viewModel = SleepHistoryViewModel(repository: repository)
        
        // Attendre que les données soient chargées
        let expectation = XCTestExpectation(description: "fetch list with one sleep session")
        
        waitForCondition(timeout: 2) {
            viewModel.sleepSessions.count == 1
        }
        
        XCTAssert(viewModel.sleepSessions.isEmpty == false)
        XCTAssert(viewModel.sleepSessions.first?.quality == 4)
        XCTAssert(viewModel.sleepSessions.first?.duration == 480)
        XCTAssert(viewModel.sleepSessions.first?.startDate == startDate)
    }
    
    func test_WhenAddingMultipleSleepSessionsInDatabase_FetchSleepSessions_ReturnAListContainingTheSessionsInTheRightOrder() {
        let persistenceController = PersistenceController(inMemory: true)
        let testContext = persistenceController.container.viewContext
        emptyEntities(context: testContext)
        
        let date1 = Date()
        let date2 = Date(timeIntervalSinceNow: -(60*60*24))
        let date3 = Date(timeIntervalSinceNow: -(60*60*24*2))
        
        addSleepSession(context: testContext,
                       startDate: date1,
                       duration: 480,
                       quality: 5,
                       userFirstName: "Eric",
                       userLastName: "Marcus")
        
        addSleepSession(context: testContext,
                       startDate: date3,
                       duration: 420,
                       quality: 3,
                       userFirstName: "Bob",
                       userLastName: "Marceau")
        
        addSleepSession(context: testContext,
                       startDate: date2,
                       duration: 360,
                       quality: 4,
                       userFirstName: "Fred",
                       userLastName: "Martin")
        
        let repository = SleepRepository(viewContext: testContext)
        let viewModel = SleepHistoryViewModel(repository: repository)
        
        // Attendre que les 3 sessions soient chargées
        waitForCondition(timeout: 2) {
            viewModel.sleepSessions.count == 3
        }
        
        XCTAssert(viewModel.sleepSessions.count == 3)
        XCTAssert(viewModel.sleepSessions[0].quality == 5)
        XCTAssert(viewModel.sleepSessions[1].quality == 4)
        XCTAssert(viewModel.sleepSessions[2].quality == 3)
    }
    
    func test_WhenReloadIsCalled_FetchSleepSessions_UpdatesList() {
        let persistenceController = PersistenceController(inMemory: true)
        let testContext = persistenceController.container.viewContext
        emptyEntities(context: testContext)
        
        let repository = SleepRepository(viewContext: testContext)
        let viewModel = SleepHistoryViewModel(repository: repository)
        
        // Vérifier que la liste est vide initialement
        XCTAssert(viewModel.sleepSessions.isEmpty)
        
        // Ajouter une session
        let startDate = Date()
        addSleepSession(context: testContext,
                       startDate: startDate,
                       duration: 480,
                       quality: 4,
                       userFirstName: "Test",
                       userLastName: "User")
        
        // Appeler reload
        viewModel.reload()
        
        // Attendre que la session soit chargée
        waitForCondition(timeout: 2) {
            viewModel.sleepSessions.count == 1
        }
        
        XCTAssert(viewModel.sleepSessions.count == 1)
        XCTAssert(viewModel.sleepSessions.first?.quality == 4)
    }
    
    // MARK: - Helper Methods
    
    private func waitForCondition(timeout: TimeInterval, condition: @escaping () -> Bool) {
        let deadline = Date().addingTimeInterval(timeout)
        
        while Date() < deadline {
            if condition() {
                return
            }
            RunLoop.current.run(until: Date().addingTimeInterval(0.01))
        }
        
        XCTFail("Condition not met within timeout")
    }
    
    private func emptyEntities(context: NSManagedObjectContext) {
        let fetchRequest = Sleep.fetchRequest()
        let objects = try! context.fetch(fetchRequest)
        
        for sleep in objects {
            context.delete(sleep)
        }
        
        try! context.save()
    }
    
    private func addSleepSession(context: NSManagedObjectContext, startDate: Date, duration: Int, quality: Int, userFirstName: String, userLastName: String) {
        let newUser = User(context: context)
        newUser.firstName = userFirstName
        newUser.lastName = userLastName
        try! context.save()
        
        let newSleep = Sleep(context: context)
        newSleep.startDate = startDate
        newSleep.duration = Int64(duration)
        newSleep.quality = Int64(quality)
        newSleep.user = newUser
        try! context.save()
    }
}
