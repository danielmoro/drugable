//
//  Created by Daniel Moro on 8.3.21.
//  Copyright © 2021 Daniel Moro. All rights reserved.
//

import Narcos
import SwiftUI

extension Reminder: Identifiable {
    public var id: UUID {
        UUID()
    }
}

struct ReminderList: View {
    let reminders: [Reminder]
    var body: some View {
        List(reminders) { reminder in
            ReminderCell(reminder: reminder)
        }
        .listStyle(GroupedListStyle())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ReminderList(reminders: [
                Reminder(name: "Reminder 1"),
                Reminder(name: "Reminder 2"),
                Reminder(name: "Reminder 3")
            ])
        }
    }
}
