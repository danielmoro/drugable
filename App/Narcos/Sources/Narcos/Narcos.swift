
protocol Router {
    func navigateToHome()
    func navigateToNewReminder(with completion: ((Reminder?) -> Void))
}

struct Reminder {
    
}

class Narcos {
    
    private var router: Router
    
    var reminders: [Reminder] = []
    
    init(router: Router) {
        self.router = router
    }
    
    func start() {
        router.navigateToHome()
    }
    
    func createReminder() {
        router.navigateToNewReminder { (reminder) in
            if let reminder = reminder {
                reminders.append(reminder)
            }
            
            router.navigateToHome()
        }
    }
}
