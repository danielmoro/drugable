import XCTest
@testable import Narcos



final class NarcosTests: XCTestCase {

    func test_start_navigatesToHome() throws {
        let router = RouterSpy()
        let engine = Narcos(router: router)
        
        engine.start()
        
        XCTAssertEqual(router.routesCount, 1)
    }
    
    func test_startAndCreatesNewReminder_navigatesToNewReminder() throws {
        let router = RouterSpy()
        let engine = Narcos(router: router)
        
        engine.start()
        engine.createReminder()
        
        XCTAssertEqual(router.routes, ["home", "new reminder"])
    }
    
    func test_createReminderAndCommits_remindersCountIncrements(){
        let router = RouterSpy()
        let engine = Narcos(router: router)
        
        engine.start()
        engine.createReminder()
        
        XCTAssertEqual(engine.reminders.count, 1)
    }
    
    private class RouterSpy: Router {
        func navigateToNewReminder() {
            routes.append("new reminder")
        }
        
        var routesCount: Int {
            routes.count
        }
        
        var routes: [String] = []
        func navigateToHome() {
            routes.append("home")
        }
    }
}
