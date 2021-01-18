
protocol Router {
    func navigateToHome()
    func navigateToNewReminder(with completion: @escaping ((Reminder?) -> Void))
    func navigateToEditReminder(reminder: Reminder, with completion: @escaping ((Reminder) -> Void))

}

struct Reminder: Equatable {
    var name: String
}

class Narcos {
    
    private var router: Router
    
    var reminders: [Reminder]
    
    init(router: Router, reminders: [Reminder] = []) {
        self.router = router
        self.reminders = reminders
    }
    
    func start() {
        router.navigateToHome()
    }
    
    func createReminder() {
        router.navigateToNewReminder {[weak self] (reminder) in
            if let reminder = reminder {
                self?.reminders.append(reminder)
            }
            
            self?.router.navigateToHome()
        }
    }
    
    func editReminder(at index: Int) {
        router.navigateToEditReminder(reminder: reminders[index]) {[weak self] (reminder) in
            self?.reminders.remove(at: index)
            self?.reminders.insert(reminder, at: index)
        }
    }
    //test
}
