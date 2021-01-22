@testable import Narcos
import XCTest

final class NarcosTests: XCTestCase {
    func test_start_navigatesToHome() throws {
        let (sut, router) = makeSUT()

        sut.start()

        XCTAssertEqual(router.routesCount, 1)
    }

    func test_createReminder_commit_remindersCountIncrements() throws {
        let (sut, router) = makeSUT()
        router.newReminder = makeReminder()

        sut.start()
        sut.createReminder()

        XCTAssertEqual(sut.reminders.count, 1)
        XCTAssertEqual(router.routes, ["home", "new reminder", "home"])
    }

    func test_createReminder_cancel_remindersCountUnchanged() {
        let (sut, router) = makeSUT()

        sut.start()
        sut.createReminder()

        XCTAssertEqual(sut.reminders.count, 0)
        XCTAssertEqual(router.routes, ["home", "new reminder", "home"])
    }

    func test_editReminder_commit_reminderChanged() {
        let reminder1 = makeReminder(name: "R1")
        let reminder2 = makeReminder(name: "R2")
        let reminders = [reminder1, reminder2]
        let (sut, router) = makeSUT(reminders: reminders)
        router.editReminderCompletion = { reminder in
            if reminder == reminder1 {
                var reminderNew = reminder
                reminderNew.name = "updatedName"
                return reminderNew
            } else {
                var reminderNew = reminder
                reminderNew.name = "updatedName1"
                return reminderNew
            }
        }
        sut.editReminder(at: 0)
        XCTAssertEqual(sut.reminders[0].name, "updatedName")

        sut.editReminder(at: 1)
        XCTAssertEqual(sut.reminders[1].name, "updatedName1")
    }

    func test_editReminder_cancel_reminderUnchanged() {
        let reminder = makeReminder(name: "L1")
        let (sut, router) = makeSUT(reminders: [reminder])
        router.editReminderCompletion = { reminder in
            reminder
        }

        sut.editReminder(at: 0)
        XCTAssertEqual(sut.reminders[0].name, "L1")
    }

    func test_editReminderWithSameName_commit_reminderChanged() {
        let reminder1 = makeReminder(name: "R1")
        let reminder2 = makeReminder(name: "R1")
        let reminders = [reminder1, reminder2]
        let (sut, router) = makeSUT(reminders: reminders)
        router.editReminderCompletion = { reminder in
            var reminderNew = reminder
            reminderNew.name = "updatedName"
            return reminderNew
        }
        sut.editReminder(at: 1)

        XCTAssertEqual(sut.reminders[0].name, "R1")

        XCTAssertEqual(sut.reminders[1].name, "updatedName")
    }

    func test_editReminder_navigatesToEditScreen() {
        let (sut, router) = makeSUT(reminders: [makeReminder()])

        sut.start()
        sut.editReminder(at: 0)

        XCTAssertEqual(router.routes, ["home", "edit reminder"])
    }

    func test_deleteReminder_commit_remindersCountDecremented() {
        let reminder1 = makeReminder()
        let reminder2 = makeReminder()
        let (sut, _) = makeSUT(reminders: [reminder1, reminder2])

        sut.deleteReminder(at: 1)
        XCTAssertEqual(sut.reminders.count, 1)
    }

    func test_start_withExistingReminders_validReminerCount() {
        let reminders = [makeReminder(), makeReminder()]
        let (sut, _) = makeSUT(reminders: reminders)

        XCTAssertEqual(sut.reminders.count, 2)
    }

    // MARK: -

    private func makeReminder(name: String = "") -> Reminder {
        return Reminder(name: name)
    }

    private func makeSUT(reminders: [Reminder] = []) -> (Narcos, RouterSpy) {
        let router = RouterSpy()
        return (Narcos(router: router, reminders: reminders), router)
    }

    private class RouterSpy: Router {
        var newReminder: Reminder?
        var editReminderCompletion: ((Reminder) -> Reminder)?

        func navigateToNewReminder(with completion: (Reminder?) -> Void) {
            routes.append("new reminder")
            completion(newReminder)
        }

        func navigateToEditReminder(reminder: Reminder, with completion: @escaping ((Reminder) -> Void)) {
            routes.append("edit reminder")
            completion(editReminderCompletion?(reminder) ?? reminder)
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
