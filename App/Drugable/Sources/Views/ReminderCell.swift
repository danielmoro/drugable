//
//  Created by Daniel Moro on 8.3.21.
//  Copyright © 2021 Daniel Moro. All rights reserved.
//

import Narcos
import SwiftUI

struct ReminderCell: View {
    
    @StateObject var reminder: ReminderViewModel

    var body: some View {
        HStack {
            VStack(alignment: .leading, content: {
                Text(reminder.name)
                        .font(.title3)
                Text(reminder.dateAsString)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            })
            Spacer()
            MyToggle(isOn: $reminder.isOn).fixedSize()
        }
    }
}

struct ReminderCell_Previews: PreviewProvider {
    static var previews: some View {
        List {
            ReminderCell(reminder: ReminderViewModel.dumbReminder())
            ReminderCell(reminder: ReminderViewModel.dumbReminder())
            ReminderCell(reminder: ReminderViewModel.dumbReminder())
        }
    }
}
