//
//  File.swift
//
//
//  Created by Mirjana Milic on 1/29/21.
//

import Foundation
@testable import Narcos

class RouterSpy: Router {
    var newReminderCompletion: (() -> Reminder)?
    var editReminderCompletion: ((Reminder) -> Reminder)?
    var routesCount: Int {
        routes.count
    }

    var routes: [String] = []

    func navigateToHome() {
        routes.append("home")
    }

    func navigateToNewReminder(with completion: (Reminder?) -> Void) {
        routes.append("new reminder")
        let reminder = newReminderCompletion?()
        completion(reminder)
    }

    func navigateToEditReminder(_ reminder: Reminder, with completion: @escaping ((Reminder) -> Void)) {
        routes.append("edit reminder")
        let reminder = editReminderCompletion?(reminder) ?? reminder
        completion(reminder)
    }

    func navigateToNotification(for _: Reminder) {
        routes.append("notification")
    }
}
