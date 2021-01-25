//
//  Watcher.swift
//  Narcos
//
//  Created by Daniel Moro on 22.1.21..
//

import Foundation

class Watcher {
    var scheduledReminders : Set<Reminder> = []
    func schedule(reminder : Reminder) {
        scheduledReminders.insert(reminder)
    }

    func unschedule(reminder: Reminder) {
        scheduledReminders.remove(reminder)
    }
    
    func isScheduled(reminder : Reminder) -> Bool {
        return scheduledReminders.contains(reminder)
    }
}
