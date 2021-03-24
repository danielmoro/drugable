//
//  ReminderViewModel.swift
//  Drugable
//
//  Created by Vladimir Jeremic on 3/10/21.
//

import Foundation
import Narcos
import Combine

enum ValidationMessage: Equatable {
    case success
    case failed(message: String)
    
    var isValid: Bool {
        get {
            return self == ValidationMessage.success
        }
    }
}

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
            let df = DateFormatter()
            df.dateStyle = .full
            df.timeStyle = .short
            return df.string(from: reminder.date)
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
    
    func isValid() -> ValidationMessage {
        
        var result = true
        var resultString: String = ""
        if self.name.count == 0  {
            result = false
            resultString = resultString + "Name is required"
        }
        
        if result {
            return .success
        }
        
        return .failed(message: resultString)
    }
}

class ReminderFetcher: ObservableObject {
    
    @Published var reminders: [ReminderViewModel] = []
    var isLoading = false
    var disposables: Set<AnyCancellable> = []
    
    func fetchReminder() {
        if reminders.count > 0 {
            return
        }
        isLoading.toggle()
        reminders = []
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.isLoading.toggle()
            JSONdecodeFromAssets(assetName: "reminders", type: [Reminder].self).sink { error in
                //
            } receiveValue: { reminder in
                var rems: [ReminderViewModel] = []
                for r in reminder {
                    rems.append(ReminderViewModel(reminder: r))
                }
                self.reminders = rems
            }.store(in: &self.disposables)


        }
    }
        
    func addReminder(_ reminder: ReminderViewModel) {
        if self.reminders.contains(reminder) == false {
            self.reminders.append(reminder)
        }
    }
    
    func deleteReminderAtIndex(_ index: IndexSet) {
        self.reminders.remove(atOffsets: index)
    }
    
    func canDeleteReminder(_ reminder: ReminderViewModel) -> Bool {
        if let index = self.reminders.firstIndex(of: reminder) {
            return index % 2 == 0
        }
        return true
    }
    
    var selectedReminder: ReminderViewModel?
}
