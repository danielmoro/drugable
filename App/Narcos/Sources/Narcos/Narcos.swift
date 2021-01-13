
protocol Router {
    func navigateToHome()
    func navigateToNewReminder()
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
        router.navigateToNewReminder()
    }
}
