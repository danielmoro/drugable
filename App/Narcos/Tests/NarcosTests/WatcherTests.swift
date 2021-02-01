//
//  File.swift
//  
//
//  Created by Mirjana Milic on 1/29/21.
//

import Foundation
import XCTest
import CombineSchedulers
@testable import Narcos

final class WatcherTests: XCTestCase {
    
    func test_scheduleReminder_schedulesReminerInWatcher() {
        // given
        let reminder = makeReminder()
        let (sut, _, _) = makeSUT()
        // let (sut, _) = makeSUT(reminders: [reminder])
        // when
        sut.schedule(reminder: reminder)
        // what
        XCTAssertTrue(sut.isScheduled(reminder: reminder))
    }
    
    func test_unscheduleReminder_unschedulesReminerInWatcher() {
        let reminder = makeReminder()
        let (sut, _, _) = makeSUT()

        sut.schedule(reminder: reminder)
        sut.unschedule(reminder: reminder)
        
        XCTAssertFalse(sut.isScheduled(reminder: reminder))
    }
    
    func test_scheduleReminderTwice_scheduledRemindersCountNotChanged() {
        let reminder = makeReminder()
        let (sut, _, _) = makeSUT()

        sut.schedule(reminder: reminder)
        sut.schedule(reminder: reminder)
        
        XCTAssertEqual(sut.scheduledReminders.count, 1)
    }
    
    func test_onTimeReminder_reminderNotificationIsShown() {
        let (sut, router, scheduler) = makeSUT()
        let reminder = makeReminder(date: Date().advanced(by: 10000000))
        sut.schedule(reminder: reminder)
        
        scheduler.advance(by: .seconds(10000000))

        
        XCTAssertEqual(router.routes, ["notification"])
    }
    
    private func makeReminder(name: String = "", date: Date = Date()) -> Reminder {
        Reminder(name: name, date: date)
    }
    
    private func makeSUT() -> (
        Watcher,
        RouterSpy,
        TestScheduler<DispatchQueue.SchedulerTimeType, DispatchQueue.SchedulerOptions>
    ) {
        let router = RouterSpy()
        let scheduler = DispatchQueue.testScheduler
        let watcher = Watcher(scheduler: AnyScheduler(scheduler))
        let _ = Narcos(router: router, watcher: watcher)
        return (watcher, router, scheduler)
    }
}
