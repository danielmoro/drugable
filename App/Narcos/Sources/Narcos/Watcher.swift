//
//  Watcher.swift
//  Narcos
//
//  Created by Daniel Moro on 22.1.21..
//

import Foundation
import CombineSchedulers

class Watcher {
    init(scheduler: AnySchedulerOf<DispatchQueue>, scheduledReminders: Set<Reminder> = []) {
        self.scheduler = scheduler
        self.scheduledReminders = scheduledReminders
    }
    
    
    private var scheduler: AnySchedulerOf<DispatchQueue>
    
    var scheduledReminders : Set<Reminder> = []
    func schedule(reminder : Reminder) {
        scheduledReminders.insert(reminder)
        let diff = reminder.date.timeIntervalSinceNow

        scheduler.schedule(after: scheduler.now.advanced(by: .seconds(diff))) {
            //notify
        }
    }

    func unschedule(reminder: Reminder) {
        scheduledReminders.remove(reminder)
    }
    
    func isScheduled(reminder : Reminder) -> Bool {
        return scheduledReminders.contains(reminder)
    }
}
