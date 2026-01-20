
import XCTest
import CoreData
@testable import Arista

final class UserRepositoryTests: XCTestCase {
    
    // MARK: - Helper Methods
    
    private func emptyEntities(context: NSManagedObjectContext) {
        let fetchRequest = User.fetchRequest()
        let objects = try! context.fetch(fetchRequest)
        
        for user in objects {
            context.delete(user)
        }
        
        try! context.save()
    }
    
    private func addUser(context: NSManagedObjectContext, firstName: String, lastName: String) {
        let newUser = User(context: context)
        newUser.firstName = firstName
        newUser.lastName = lastName
        try! context.save()
    }
    
    // MARK: - Tests getUser()
    
    func test_WhenNoUserIsInDatabase_GetUser_ReturnsNil() {
        let persistenceController = PersistenceController(inMemory: true)
        emptyEntities(context: persistenceController.container.viewContext)
        
        let repository = UserRepository(viewContext: persistenceController.container.viewContext)
        let user = try! repository.getUser()
        
        XCTAssertNil(user)
    }
    
    func test_WhenOneUserIsInDatabase_GetUser_ReturnsTheUser() {
        let persistenceController = PersistenceController(inMemory: true)
        emptyEntities(context: persistenceController.container.viewContext)
        
        addUser(context: persistenceController.container.viewContext,
               firstName: "Jean",
               lastName: "Dupont")
        
        let repository = UserRepository(viewContext: persistenceController.container.viewContext)
        let user = try! repository.getUser()
        
        XCTAssertNotNil(user)
        XCTAssert(user?.firstName == "Jean")
        XCTAssert(user?.lastName == "Dupont")
    }
    
    func test_WhenMultipleUsersAreInDatabase_GetUser_ReturnsFirstUser() {
        let persistenceController = PersistenceController(inMemory: true)
        emptyEntities(context: persistenceController.container.viewContext)
        
        addUser(context: persistenceController.container.viewContext,
               firstName: "Jean",
               lastName: "Dupont")
        
        addUser(context: persistenceController.container.viewContext,
               firstName: "Marc",
               lastName: "Antoine")
        
        let repository = UserRepository(viewContext: persistenceController.container.viewContext)
        let user = try! repository.getUser()
        
        XCTAssertNotNil(user)
    }
}
