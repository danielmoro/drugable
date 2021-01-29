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
        let (sut, _) = makeSUT()
        // let (sut, _) = makeSUT(reminders: [reminder])
        // when
        sut.schedule(reminder: reminder)
        // what
        XCTAssertTrue(sut.isScheduled(reminder: reminder))
    }
    
    func test_unscheduleReminder_unschedulesReminerInWatcher() {
        let reminder = makeReminder()
        let (sut, _) = makeSUT()

        sut.schedule(reminder: reminder)
        sut.unschedule(reminder: reminder)
        
        XCTAssertFalse(sut.isScheduled(reminder: reminder))
    }
    
    func test_scheduleReminderTwice_scheduledRemindersCountNotChanged() {
        let reminder = makeReminder()
        let (sut, _) = makeSUT()

        sut.schedule(reminder: reminder)
        sut.schedule(reminder: reminder)
        
        XCTAssertEqual(sut.scheduledReminders.count, 1)
    }
    
    func test_onTimeReminder_reminderNotificationIsShown() {
        let reminder = makeReminder()
        let (sut, router) = makeSUT()
        sut.schedule(reminder: reminder)
        //advance to scheduled time
        
        XCTAssertEqual(router.routes, ["notification"])
    }
    
    private func makeReminder(name: String = "") -> Reminder {
        Reminder(name: name)
    }
    
    private func makeSUT() -> (Watcher, RouterSpy) {
        let router = RouterSpy()
        let watcher = Watcher()
        let _ = Narcos(router: router, watcher: watcher)
        return (watcher, router)
    }
}
