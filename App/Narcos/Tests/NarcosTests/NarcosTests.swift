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

    func test_createReminder_commitAndSchedule_reminderScheduled() throws {
        let (sut, router) = makeSUT()
        router.newReminder = makeReminder()
        router.newReminder?.isScheduled = true

        sut.start()
        sut.createReminder()
        
        XCTAssertTrue(sut.watcher.isScheduled(reminder: sut.reminders[0]))
    }
    
    func test_createReminder_commitWithoutScheduling_reminderIsNotScheduled() throws {
        let (sut, router) = makeSUT()
        router.newReminder = makeReminder()
        router.newReminder?.isScheduled = false

        sut.start()
        sut.createReminder()
        
        XCTAssertFalse(sut.watcher.isScheduled(reminder: router.newReminder!))
    }
    
    func test_createReminder_cancel_remindersCountUnchanged() {
        let (sut, router) = makeSUT()

        sut.start()
        sut.createReminder()

        XCTAssertEqual(sut.reminders.count, 0)
        XCTAssertEqual(router.routes, ["home", "new reminder", "home"])
    }

    func test_editReminder_changeNameAndCommit_reminderNameChanged() {
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
    
    func test_editReminder_schedule_reminderScheduled() {

        var reminder = makeReminder()
        reminder.isScheduled = true
        let (sut, _) = makeSUT(reminders: [reminder])
        
        sut.editReminder(at: 0)
        
        XCTAssertTrue(sut.watcher.isScheduled(reminder: sut.reminders[0]))
    }
    
    func test_editReminder_unschedule_reminderUnscheduled() {
        var reminder = makeReminder()
        reminder.isScheduled = false
        let (sut, _) = makeSUT(reminders: [reminder])
        sut.watcher.schedule(reminder: reminder)
        
        XCTAssertTrue(sut.watcher.isScheduled(reminder: sut.reminders[0]))

        sut.editReminder(at: 0)
        
        XCTAssertFalse(sut.watcher.isScheduled(reminder: sut.reminders[0]))
    }
    
    func test_editReminder_changeNameofScheduledReminder_reminderIsScheduled() {
        var reminder = makeReminder()
        reminder.isScheduled = true
        let (sut, router) = makeSUT(reminders: [reminder])
        sut.watcher.schedule(reminder: reminder)
        
        router.editReminderCompletion = { reminder in
                var reminderNew = reminder
                reminderNew.name = "updatedName"
                return reminderNew
        }
        
        XCTAssertTrue(sut.watcher.isScheduled(reminder: sut.reminders[0]))
        
        sut.editReminder(at: 0)
        
        XCTAssertTrue(sut.watcher.isScheduled(reminder: sut.reminders[0]))
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

    func test_scheduleReminder_schedulesReminerInWatcher() {
        // given
        let reminder = makeReminder()
        let sut = Watcher()
        // let (sut, _) = makeSUT(reminders: [reminder])
        // when
        sut.schedule(reminder: reminder)
        // what
        XCTAssertTrue(sut.isScheduled(reminder: reminder))
    }
    
    func test_unscheduleReminder_unschedulesReminerInWatcher() {
        let reminder = makeReminder()
        let sut = Watcher()
        
        sut.schedule(reminder: reminder)
        sut.unschedule(reminder: reminder)
        
        XCTAssertFalse(sut.isScheduled(reminder: reminder))
    }
    
    func test_scheduleReminderTwice_scheduledRemindersCountNotChanged() {
        let reminder = makeReminder()
        let sut = Watcher()
        
        sut.schedule(reminder: reminder)
        sut.schedule(reminder: reminder)
        
        XCTAssertEqual(sut.scheduledReminders.count, 1)
    }
    

    // MARK: -

    private func makeReminder(name: String = "") -> Reminder {
        Reminder(name: name)
    }

    private func makeSUT(reminders: [Reminder] = []) -> (Narcos, RouterSpy) {
        let router = RouterSpy()
        let watcher = Watcher()
        return (Narcos(router: router, reminders: reminders, watcher: watcher), router)
    }

    private class RouterSpy: Router {
        var newReminder: Reminder?
        var editReminderCompletion: ((Reminder) -> Reminder)?

        func navigateToNewReminder(with completion: (Reminder?) -> Void) {
            routes.append("new reminder")
            let reminder = newReminder
            completion(reminder)
        }

        func navigateToEditReminder(reminder: Reminder, with completion: @escaping ((Reminder) -> Void)) {
            routes.append("edit reminder")
            let reminder = editReminderCompletion?(reminder) ?? reminder
            completion(reminder)
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
