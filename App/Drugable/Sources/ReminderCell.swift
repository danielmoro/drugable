//
//  Created by Daniel Moro on 8.3.21.
//  Copyright © 2021 Daniel Moro. All rights reserved.
//

import Narcos
import SwiftUI

struct ReminderCell: View {
    
    @StateObject var reminder: ReminderViewModel
    let tapHandler: () -> Void
    let showsSwitcher: Bool

    var body: some View {
        HStack {
            VStack(alignment: .leading, content: {
                Text(reminder.name)
                        .font(.title)
                Text(reminder.dateAsString)
            })
            Spacer()
            if showsSwitcher {
                Toggle("", isOn: $reminder.isOn).fixedSize()
            }
        }.onTapGesture {
            tapHandler()
        }
    }
}

struct ReminderCell_Previews: PreviewProvider {
    static var previews: some View {
        List {
            ReminderCell(reminder: ReminderViewModel.dumbReminder(), tapHandler: {
                //
            }, showsSwitcher: true)
            ReminderCell(reminder: ReminderViewModel.dumbReminder(), tapHandler: {
                //
            }, showsSwitcher: true)
            ReminderCell(reminder: ReminderViewModel.dumbReminder(), tapHandler: {
                //
            }, showsSwitcher: false)
        }
    }
}
