//
//  ReminderDetail.swift
//  Drugable
//
//  Created by Vladimir Jeremic on 3/12/21.
//

import SwiftUI
import Narcos

struct ReminderDetail: View {
    
    @EnvironmentObject var reminderFetcher: ReminderFetcher
    @StateObject var reminder: ReminderViewModel
    @Binding var isPresented: Bool
    
    var body: some View {
        
        NavigationView {
            Form {
                TextField("Required", text: $reminder.name)
                Toggle("Active", isOn: $reminder.isOn)
                DatePicker("Date", selection: $reminder.date,  displayedComponents: [.date])
                    
            }.navigationBarItems(leading: cancelButton, trailing: doneButton)
            .navigationBarTitle("", displayMode: .inline)
        }
    }
    
    private var cancelButton: some View {
        Button("Cancel") {
            isPresented = false
        }
    }
    
    private var doneButton: some View {
        Button("Done") {
            isPresented = false
            reminderFetcher.addReminder(reminder)
        }
    }
}

struct ReminderDetail_Previews: PreviewProvider {
    static var previews: some View {
        ReminderDetail(reminder: ReminderViewModel(reminder: Reminder(name: "Test", isScheduled: false, date: Date())), isPresented: .constant(true))
    }
}
