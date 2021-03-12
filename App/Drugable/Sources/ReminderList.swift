//
//  Created by Daniel Moro on 8.3.21.
//  Copyright © 2021 Daniel Moro. All rights reserved.
//

import Narcos
import SwiftUI

struct ReminderList: View {
    
    @EnvironmentObject var reminderFetcher: ReminderFetcher
    @State var reminderDetailIsPresented = false {
        didSet {
            if reminderDetailIsPresented == false {
                reminderFetcher.selectedReminder = nil
            }
        }
    }
    
    @State var isEditing = false
    
    var body: some View {
        
        NavigationView {
            ZStack {
                listView
                if reminderFetcher.isLoading == true {
                    progress
                }
            }.navigationBarTitle(Text("Reminders"), displayMode: .large)
            .navigationBarItems(leading: editButton, trailing: addButton)
        }
        .fullScreenCover(isPresented: $reminderDetailIsPresented, content: {
            ReminderDetail(reminder: reminderFetcher.selectedReminder ?? ReminderViewModel.newReminder(), isPresented: $reminderDetailIsPresented)
        })
    }
    
    private var listView: some View {
        List(reminderFetcher.reminders) { reminder in
            ReminderCell(reminder: reminder, tapHandler: {
                if reminderDetailIsPresented == false {
                    reminderFetcher.selectedReminder = reminder
                    reminderDetailIsPresented = true
                }
            }, showsSwitcher: isEditing)
        }.onAppear(perform: {
            reminderFetcher.fetchReminder()
        })
        .listStyle(GroupedListStyle())
    }
    
    private var progress: some View {
        ProgressView("Loading...").progressViewStyle(CircularProgressViewStyle())
            .navigationBarTitle(Text("Reminders"))
    }
    
    private var addButton: some View {
        Button("Add", action: {
            reminderDetailIsPresented = true
        }).disabled(reminderFetcher.isLoading == true)
    }
    
    private var editButton: some View {
        Button("Edit", action: {
            isEditing.toggle()
        }).disabled(reminderFetcher.isLoading == true)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ReminderList().environmentObject(ReminderFetcher())
        }
    }
}
