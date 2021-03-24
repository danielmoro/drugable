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
    
    init() {
        UITableView.appearance().backgroundColor = .white
    }
        
    var body: some View {
        ZStack {
            NavigationView {
                ZStack {
                    listView
                }.navigationBarTitle(
                    Text("Reminders"), displayMode: .large
                )
                .navigationBarItems(trailing: addButton)
            }
            .navigationViewStyle(StackNavigationViewStyle())
            .fullScreenCover(
                isPresented: $reminderDetailIsPresented,
                content: {
                  reminderDetail
            })
            if reminderFetcher.isLoading == true {
                progress
            }
        }
    }
    
    private var listView: some View {
        List {

            ForEach(reminderFetcher.reminders, content: { reminder in
//                ReminderCell(reminder: reminder)
//                    .onTapGesture {
//                        if reminderDetailIsPresented == false {
//                            reminderFetcher.selectedReminder = reminder
//                            reminderDetailIsPresented.toggle()
//                        }
//                    }.deleteDisabled(reminderFetcher.canDeleteReminder(reminder))
                ActionCell(leftActions: [Action(title: "l1", handler: { action in
                    //
                }, color: .red)], rightActions: [Action(title: "r1", handler: { action in
                    //
                }, color: .blue)])
            })
            .onDelete(perform: { indexSet in
                self.reminderFetcher.deleteReminderAtIndex(indexSet)
            })
        }
        .onAppear(perform: {
            reminderFetcher.fetchReminder()
        })
        .listStyle(InsetListStyle())
    }
    
//    private var listView: some View {
//        ScrollView(.vertical, showsIndicators: true, content: {
//            LazyVStack {
//                ForEach(reminderFetcher.reminders) { reminder in
//                    ReminderCell(reminder: reminder)
//                        .onTapGesture {
//                            if reminderDetailIsPresented == false {
//                                reminderFetcher.selectedReminder = reminder
//                                reminderDetailIsPresented.toggle()
//                            }
//                        }
//                    Divider()
//                }
//                .padding(.horizontal)
//            }
//        })
//        .onAppear(perform: {
//            reminderFetcher.fetchReminder()
//        })
//    }
    
    private var progress: some View {
        LoadingView(
            color: .accentColor,
            text: "Loading"
        )
    }
    
    private var addButton: some View {
        Button("Add", action: {
            reminderDetailIsPresented = true
        }).disabled(reminderFetcher.isLoading == true)
    }
    
    private var reminderDetail: some View {
        ReminderDetail(
            reminder: reminderFetcher.selectedReminder ?? ReminderViewModel.newReminder(),
            isPresented: $reminderDetailIsPresented
        )
//        UIKitController()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ReminderList().environmentObject(ReminderFetcher())
        }
    }
}
