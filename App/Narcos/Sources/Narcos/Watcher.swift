//
//  Watcher.swift
//  Narcos
//
//  Created by Daniel Moro on 22.1.21..
//

import CombineSchedulers
import Foundation

// protocol TestProtocol {
//    associatedtype T
//    func test(_: T)
// }
//
//
// struct AnyTestProtocol<T> : TestProtocol {
//    var _test : (_: T) -> Void
//    init<TP : TestProtocol>(tp: TP) where T == TP.T {
//        _test = { (param) in
//            tp.test(param)
//        }
//    }
//
//    func test(_ arg: T) {
//        _test(arg)
//    }
// }
//
// extension TestProtocol {
//    func eraseToAnyTestProtocol() -> AnyTestProtocol<T> {
//        return AnyTestProtocol(tp: self)
//    }
// }
//
// class TestTest : TestProtocol {
//
//    func test(_: String) {
//        //
//    }
//
// }
//
// var arr = Array<AnyTestProtocol<String>>()
//
// var intTP = TestTest()
// var t = intTP.eraseToAnyTestProtocol()
//
// arr.append(t)

class Watcher {
    init(scheduler: AnySchedulerOf<DispatchQueue>, scheduledReminders: Set<Reminder> = [], router: Router) {
        self.scheduler = scheduler
        self.scheduledReminders = scheduledReminders
        self.router = router
    }

    private var scheduler: AnySchedulerOf<DispatchQueue>
    private var router: Router

    var scheduledReminders: Set<Reminder> = []
    func schedule(reminder: Reminder) {
        scheduledReminders.insert(reminder)
        let diff = reminder.date.timeIntervalSinceNow

        scheduler.schedule(after: scheduler.now.advanced(by: .seconds(diff))) {[weak self] in
            if(self?.scheduledReminders.contains(reminder) == true) {
                self?.router.navigateToNotification(for: reminder)
            }
        }
    }

    func unschedule(reminder: Reminder) {
        scheduledReminders.remove(reminder)
    }

    func isScheduled(reminder: Reminder) -> Bool {
        scheduledReminders.contains(reminder)
    }
}
