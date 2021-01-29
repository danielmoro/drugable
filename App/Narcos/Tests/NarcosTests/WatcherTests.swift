//
//  File.swift
//  
//
//  Created by Mirjana Milic on 1/29/21.
//

import Foundation
import XCTest
@testable import Narcos

final class WatcherTests: XCTestCase {
    
    func test_scheduleReminder_schedulesReminerInWatcher() {
        // given
        let reminder = makeReminder()
        let sut = Watcher()
        // let (sut, _) = makeSUT(reminders: [reminder])
        // when
        sut.schedule(reminder: reminder)
        // what
        XCTAssertTrue(sut.isScheduled(reminder: reminder))
    }
    
    func test_unscheduleReminder_unschedulesReminerInWatcher() {
        let reminder = makeReminder()
        let sut = Watcher()
        
        sut.schedule(reminder: reminder)
        sut.unschedule(reminder: reminder)
        
        XCTAssertFalse(sut.isScheduled(reminder: reminder))
    }
    
    func test_scheduleReminderTwice_scheduledRemindersCountNotChanged() {
        let reminder = makeReminder()
        let sut = Watcher()
        
        sut.schedule(reminder: reminder)
        sut.schedule(reminder: reminder)
        
        XCTAssertEqual(sut.scheduledReminders.count, 1)
    }
    
    private func makeReminder(name: String = "") -> Reminder {
        Reminder(name: name)
    }
}
