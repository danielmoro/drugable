protocol Router {
    func navigateToHome()
    func navigateToNewReminder(with completion: @escaping ((Reminder?, Bool) -> Void))
    func navigateToEditReminder(reminder: Reminder, with completion: @escaping ((Reminder, Bool) -> Void))
}

struct Reminder: Equatable, Hashable {
    var name: String
    
}

class Narcos {
    private var router: Router
    var watcher : Watcher

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
        router.navigateToNewReminder { [weak self] (reminder, shouldSchedule) in
            if let reminder = reminder {
                self?.reminders.append(reminder)
                if shouldSchedule == true {
                    self?.watcher.schedule(reminder: reminder)
                }
            }
            self?.router.navigateToHome()
        }
    }

    func editReminder(at index: Int) {
        router.navigateToEditReminder(reminder: reminders[index]) { [weak self] reminder, shouldSchedule  in
            self?.reminders.remove(at: index)
            if shouldSchedule == true {
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
