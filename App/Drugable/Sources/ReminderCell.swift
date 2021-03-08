//
//  Created by Daniel Moro on 8.3.21.
//  Copyright © 2021 Daniel Moro. All rights reserved.
//

import Narcos
import SwiftUI

struct ReminderCell: View {
    let reminder: Reminder
    var body: some View {
        HStack {
            Text(reminder.name)
                .layoutPriority(1)
            Spacer()
            Toggle("", isOn: .constant(reminder.isScheduled))
        }
        .background(Color.red)
    }
}

struct ReminderCell_Previews: PreviewProvider {
    static var previews: some View {
        List {
            ReminderCell(reminder: Reminder(name: "R1"))
            ReminderCell(reminder: Reminder(name: "R2", isScheduled: true))
            ReminderCell(reminder: Reminder(name: "R3"))
        }
    }
}
