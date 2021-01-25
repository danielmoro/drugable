//
//  Watcher.swift
//  Narcos
//
//  Created by Daniel Moro on 22.1.21..
//

import Foundation

class Watcher {
    var scheduledReminders = [Reminder]()
    func schedule(reminder : Reminder) {
        scheduledReminders.append(reminder)
    }

    func unschedule(reminder: Reminder) {
        if let index = scheduledReminders.firstIndex(of: reminder) {
            scheduledReminders.remove(at: index)
        }
    }
    
    func isScheduled(reminder : Reminder) -> Bool {
        return scheduledReminders.contains(reminder)
    }
}
