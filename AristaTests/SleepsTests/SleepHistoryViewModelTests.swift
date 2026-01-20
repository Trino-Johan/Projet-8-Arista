import XCTest
import CoreData
@testable import Arista

final class SleepHistoryViewModelTests: XCTestCase {
    
    // MARK: - Tests
    
    func test_WhenNoSleepSessionInDatabase_FetchSleepSessions_ReturnEmptyList() {
        let persistenceController = PersistenceController(inMemory: true)
        emptyEntities(context: persistenceController.container.viewContext)
        
        let viewModel = SleepHistoryViewModel(context: persistenceController.container.viewContext)
        
        let expectation = XCTestExpectation(description: "fetch empty list of sleep sessions")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssert(viewModel.sleepSessions.isEmpty)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1)
    }
    
    func test_WhenAddingOneSleepSessionInDatabase_FetchSleepSessions_ReturnAListContainingTheSession() {
        let persistenceController = PersistenceController(inMemory: true)
        emptyEntities(context: persistenceController.container.viewContext)
        
        let startDate = Date()
        
        addSleepSession(context: persistenceController.container.viewContext,
                       startDate: startDate,
                       duration: 480,
                       quality: 4,
                       userFirstName: "Eric",
                       userLastName: "Marcus")
        
        let viewModel = SleepHistoryViewModel(context: persistenceController.container.viewContext)
        
        let expectation = XCTestExpectation(description: "fetch list with one sleep session")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssert(viewModel.sleepSessions.isEmpty == false)
            XCTAssert(viewModel.sleepSessions.first?.quality == 4)
            XCTAssert(viewModel.sleepSessions.first?.duration == 480)
            XCTAssert(viewModel.sleepSessions.first?.startDate == startDate)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1)
    }
    
    func test_WhenAddingMultipleSleepSessionsInDatabase_FetchSleepSessions_ReturnAListContainingTheSessionsInTheRightOrder() {
        let persistenceController = PersistenceController(inMemory: true)
        emptyEntities(context: persistenceController.container.viewContext)
        
        let date1 = Date()
        let date2 = Date(timeIntervalSinceNow: -(60*60*24))
        let date3 = Date(timeIntervalSinceNow: -(60*60*24*2))
        
        addSleepSession(context: persistenceController.container.viewContext,
                       startDate: date1,
                       duration: 480,
                       quality: 5,
                       userFirstName: "Eric",
                       userLastName: "Marcus")
        
        addSleepSession(context: persistenceController.container.viewContext,
                       startDate: date3,
                       duration: 420,
                       quality: 3,
                       userFirstName: "Bob",
                       userLastName: "Marceau")
        
        addSleepSession(context: persistenceController.container.viewContext,
                       startDate: date2,
                       duration: 360,
                       quality: 4,
                       userFirstName: "Fred",
                       userLastName: "Martin")
        
        let viewModel = SleepHistoryViewModel(context: persistenceController.container.viewContext)
        
        let expectation = XCTestExpectation(description: "fetch list with multiple sleep sessions")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssert(viewModel.sleepSessions.count == 3)
            XCTAssert(viewModel.sleepSessions[0].quality == 5)
            XCTAssert(viewModel.sleepSessions[1].quality == 4)
            XCTAssert(viewModel.sleepSessions[2].quality == 3)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1)
    }
    
    // MARK: - Helper Methods
    
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
