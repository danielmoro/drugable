import XCTest
@testable import Narcos



final class NarcosTests: XCTestCase {

    func test_start_navigatesToHome() throws {
        
        let (sut, router) = makeSUT()
        
        sut.start()
        
        XCTAssertEqual(router.routesCount, 1)
    }
    
    func test_createReminderAndCommits_remindersCountIncrements() throws {
        let (sut, router) = makeSUT()
        router.newReminder = Reminder()
        
        sut.start()
        sut.createReminder()
        
        XCTAssertEqual(sut.reminders.count, 1)
        XCTAssertEqual(router.routes, ["home", "new reminder", "home"])
    }
    
    func test_createReminderAndCancel_remindersCountUnchanged() {
       
        let (sut, router) = makeSUT()

        sut.start()
        sut.createReminder()
        
        XCTAssertEqual(sut.reminders.count, 0)
        XCTAssertEqual(router.routes, ["home", "new reminder", "home"])
    }
    
    private func makeSUT() -> (Narcos, RouterSpy) {
        let router = RouterSpy()
        return (Narcos(router: router), router)
    }
    
    private class RouterSpy: Router {
        var newReminder : Reminder?
        
        func navigateToNewReminder(with completion: ((Reminder?) -> Void)) {
            routes.append("new reminder")
            completion(newReminder)
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
