import XCTest
import CoreData
@testable import Arista

final class SleepRepositoryTests: XCTestCase {
    
    // MARK: - Helper Methods
    
    private func emptyEntities(context: NSManagedObjectContext) {
        let fetchRequest = Sleep.fetchRequest()
        let objects = try! context.fetch(fetchRequest)
        
        for sleep in objects {
            context.delete(sleep)
        }
        
        try! context.save()
    }
    
    private func addSleep(context: NSManagedObjectContext, quality: Int, duration: Int, startDate: Date, userFirstName: String, userLastName: String) {
        let newUser = User(context: context)
        newUser.firstName = userFirstName
        newUser.lastName = userLastName
        try! context.save()
        
        let newSleep = Sleep(context: context)
        newSleep.quality = Int64(quality)
        newSleep.duration = Int64(duration)
        newSleep.startDate = startDate
        newSleep.user = newUser
        try! context.save()
    }
    
    // MARK: - Tests getSleepSessions()
    
    func test_WhenNoSleepIsInDatabase_GetSleepSessions_ReturnEmptyList() {
        let persistenceController = PersistenceController(inMemory: true)
        emptyEntities(context: persistenceController.container.viewContext)
        
        let data = SleepRepository(viewContext: persistenceController.container.viewContext)
        let sleepSessions = try! data.getSleepSessions()
        
        XCTAssert(sleepSessions.isEmpty == true)
    }
    
    func test_WhenAddingOneSleepInDatabase_GetSleepSessions_ReturnAListContainingTheSleep() {
        let persistenceController = PersistenceController(inMemory: true)
        emptyEntities(context: persistenceController.container.viewContext)
        let date = Date()
        
        addSleep(context: persistenceController.container.viewContext,
                quality: 8,
                duration: 480,
                startDate: date,
                userFirstName: "Jean",
                userLastName: "Dupont")
        
        let data = SleepRepository(viewContext: persistenceController.container.viewContext)
        let sleepSessions = try! data.getSleepSessions()
        
        XCTAssert(sleepSessions.isEmpty == false)
        XCTAssert(sleepSessions.first?.quality == 8)
        XCTAssert(sleepSessions.first?.duration == 480)
        XCTAssert(sleepSessions.first?.startDate == date)
    }
    
    func test_WhenAddingMultipleSleepInDatabase_GetSleepSessions_ReturnAListContainingTheSleepInTheRightOrder() {
        let persistenceController = PersistenceController(inMemory: true)
        emptyEntities(context: persistenceController.container.viewContext)
        
        let date1 = Date()
        let date2 = Date(timeIntervalSinceNow: -(60*60*24))
        let date3 = Date(timeIntervalSinceNow: -(60*60*24*2))
        
        addSleep(context: persistenceController.container.viewContext,
                quality: 8,
                duration: 480,
                startDate: date1,
                userFirstName: "Jean",
                userLastName: "Dupont")
        
        addSleep(context: persistenceController.container.viewContext,
                quality: 5,
                duration: 360,
                startDate: date3,
                userFirstName: "Marc",
                userLastName: "Antoine")
        
        addSleep(context: persistenceController.container.viewContext,
                quality: 7,
                duration: 420,
                startDate: date2,
                userFirstName: "Charlie",
                userLastName: "Danger")
        
        let data = SleepRepository(viewContext: persistenceController.container.viewContext)
        let sleepSessions = try! data.getSleepSessions()
        
        XCTAssert(sleepSessions.count == 3)
        XCTAssert(sleepSessions[0].quality == 8)
        XCTAssert(sleepSessions[1].quality == 7)
        XCTAssert(sleepSessions[2].quality == 5)
    }
    
    // MARK: - Tests addSleepSession()
    
    func test_WhenAddingValidSleepSession_AddSleepSession_SavesItToDatabase() {
        let persistenceController = PersistenceController(inMemory: true)
        emptyEntities(context: persistenceController.container.viewContext)
        
        let repository = SleepRepository(viewContext: persistenceController.container.viewContext)
        
        try! repository.addSleepSession(
            startDate: Date(),
            duration: 480,
            quality: 8
        )
        
        let sleepSessions = try! repository.getSleepSessions()
        XCTAssert(sleepSessions.count == 1)
        XCTAssert(sleepSessions.first?.quality == 8)
        XCTAssert(sleepSessions.first?.duration == 480)
    }
    
    func test_WhenAddingMultipleSleepSessions_AddSleepSession_SavesThemAll() {
        let persistenceController = PersistenceController(inMemory: true)
        emptyEntities(context: persistenceController.container.viewContext)
        
        let repository = SleepRepository(viewContext: persistenceController.container.viewContext)
        
        try! repository.addSleepSession(startDate: Date(), duration: 480, quality: 8)
        try! repository.addSleepSession(startDate: Date(), duration: 360, quality: 6)
        
        let sleepSessions = try! repository.getSleepSessions()
        XCTAssert(sleepSessions.count == 2)
    }
}
