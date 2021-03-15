//
//  ReminderViewModel.swift
//  Drugable
//
//  Created by Vladimir Jeremic on 3/10/21.
//

import Foundation
import Narcos
import Combine

class ReminderViewModel: ObservableObject, Identifiable, Hashable {
    static func == (lhs: ReminderViewModel, rhs: ReminderViewModel) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.id)
    }
    
    var reminder: Reminder
    
    @Published var name: String {
        didSet {
            reminder.name = name
        }
    }
    @Published var isOn: Bool {
        didSet {
            reminder.isScheduled = isOn
            print(reminder.name + "\(reminder.isScheduled)")
        }
    }
    
    @Published var date: Date {
        didSet {
            reminder.date = date
        }
    }
    let id: String
    
    var dateAsString: String {
        get {
            return "\(date)"
        }
    }
    
    init(reminder: Reminder) {
        self.reminder = reminder
        self.name = reminder.name
        self.isOn = reminder.isScheduled
        self.date = reminder.date
        self.id = UUID().uuidString
    }
    
    static func dumbReminder() -> ReminderViewModel {
        return ReminderViewModel(reminder: Reminder(name: "Test", isScheduled: false, date: Date()))
    }
    
    static func newReminder() -> ReminderViewModel {
        return ReminderViewModel(reminder: Reminder(name: ""))
    }
}

class ReminderFetcher: ObservableObject {
    
    @Published var reminders: [ReminderViewModel] = []
    var isLoading = false
    
    func fetchReminder() {
        if reminders.count > 0 {
            return
        }
        isLoading.toggle()
        reminders = []
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.isLoading.toggle()
            self.reminders = [
                ReminderViewModel(reminder: Reminder(name: "R1", isScheduled: false, date: Date())),
                ReminderViewModel(reminder: Reminder(name: "R2", isScheduled: false, date: Date())),
                ReminderViewModel(reminder: Reminder(name: "R3", isScheduled: false, date: Date()))
            ]
        }
    }
        
    func addReminder(_ reminder: ReminderViewModel) {
        if self.reminders.contains(reminder) == false {
            self.reminders.append(reminder)
        }
    }
    var selectedReminder: ReminderViewModel?
}
