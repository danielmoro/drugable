import Foundation

protocol Router {
    func navigateToHome()
    func navigateToNewReminder(with completion: @escaping ((Reminder?) -> Void))
    func navigateToEditReminder(_ reminder: Reminder, with completion: @escaping ((Reminder) -> Void))
    func navigateToNotification(for reminder: Reminder)
}

struct Reminder: Equatable, Hashable {
    var name: String
    var isScheduled = false
    var date = Date()
}

class Narcos {
    private var router: Router
    var watcher: Watcher

    var reminders: [Reminder]

    init(router: Router, reminders: [Reminder] = [], watcher: Watcher) {
        self.router = router
        self.reminders = reminders
        self.watcher = watcher
    }

    func start() {
        router.navigateToHome()
    }

    func createReminder() {
        router.navigateToNewReminder { [weak self] reminder in
            if let reminder = reminder {
                self?.reminders.append(reminder)
                if reminder.isScheduled {
                    self?.watcher.schedule(reminder: reminder)
                }
            }
            self?.router.navigateToHome()
        }
    }

    func editReminder(at index: Int) {
        router.navigateToEditReminder(reminders[index]) { [weak self] reminder in
            self?.reminders.remove(at: index)
            if reminder.isScheduled {
                self?.watcher.schedule(reminder: reminder)
            } else {
                self?.watcher.unschedule(reminder: reminder)
            }
            self?.reminders.insert(reminder, at: index)
        }
    }

    func deleteReminder(at index: Int) {
        reminders.remove(at: index)
    }
}
