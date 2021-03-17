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
    @State var errorMessage: String?
    
    var body: some View {
        
        NavigationView {
            Form {
                TextField("Required", text: $reminder.name)
                Toggle("Active", isOn: $reminder.isOn)
                DatePicker("Date", selection: $reminder.date,  displayedComponents: [.date])
                    
            }.navigationBarItems(leading: cancelButton, trailing: doneButton)
            .navigationBarTitle("", displayMode: .inline)
        }.alert(isPresented: Binding(get: hasErrorMessage, set: dismissError), content: {
            Alert(title: Text("Validation warning"), message: Text(errorMessage ?? ""))
        })
    }
    
    private var cancelButton: some View {
        Button("Cancel") {
            isPresented = false
        }
    }
    
    private var doneButton: some View {
        Button("Done") {
            let isValid = reminder.isValid()
            
            switch isValid {
            case .success:
                isPresented = false
                self.reminderFetcher.addReminder(reminder)
            case .failed(message: let message):
                errorMessage = message
            }
        }
    }
    
    func hasErrorMessage() -> Bool {
        if let e = errorMessage {
            return e.count > 0
        }
        
        return false
    }
    
    func dismissError(_ dismiss: Bool) {
        errorMessage = nil
    }
}

struct ReminderDetail_Previews: PreviewProvider {
    static var previews: some View {
        ReminderDetail(reminder: ReminderViewModel(reminder: Reminder(name: "Test", isScheduled: false, date: Date())), isPresented: .constant(true))
    }
}
