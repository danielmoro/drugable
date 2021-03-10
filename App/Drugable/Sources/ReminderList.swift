//
//  Created by Daniel Moro on 8.3.21.
//  Copyright © 2021 Daniel Moro. All rights reserved.
//

import Narcos
import SwiftUI

struct ReminderList: View {
    
    @EnvironmentObject var reminderFetcher: ReminderFetcher
    
    var body: some View {
        if reminderFetcher.isLoading == false {
            List(reminderFetcher.reminders) { reminder in
                ReminderCell(reminder: reminder)
            }.onAppear(perform: {
                reminderFetcher.fetchReminder()
            })
            .listStyle(GroupedListStyle())
        } else {
            ProgressView("Loading...").progressViewStyle(CircularProgressViewStyle())
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ReminderList().environmentObject(ReminderFetcher())
        }
    }
}
