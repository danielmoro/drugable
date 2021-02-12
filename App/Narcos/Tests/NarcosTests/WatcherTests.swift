//
//  File.swift
//
//
//  Created by Mirjana Milic on 1/29/21.
//

import CombineSchedulers
import Foundation
@testable import Narcos
import XCTest

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
        let reminder = makeReminder(date: Date().advanced(by: 10_000_000))
        sut.schedule(reminder: reminder)

        scheduler.advance(by: .seconds(10_000_000))

        XCTAssertEqual(router.routes, ["notification"])
    }
    
    func test_uncsheduleReminder_notificationNotShown() {
        let (sut, router, scheduler) = makeSUT()
        let reminder = makeReminder(date: Date().advanced(by: 1000))
        
        sut.schedule(reminder: reminder)
        scheduler.advance(by: .seconds(500))
        sut.unschedule(reminder: reminder)
        scheduler.advance(by: .seconds(500))

        XCTAssertEqual(router.routes, [])
    }
    
    func test_reminderIsScheduled_watcherDeallocated_notificaitonNotShown() {
        let (_, router, scheduler) = makeSUT()
        let reminder = makeReminder(date: Date().advanced(by: 1000))
        var watcher: Watcher? = Watcher(scheduler: AnyScheduler(scheduler), router: router)

        watcher?.schedule(reminder: reminder)
        watcher = nil
        scheduler.advance(by: .seconds(1000))

        XCTAssertEqual(router.routes, [])
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
        let watcher = Watcher(scheduler: AnyScheduler(scheduler), router: router)
        _ = Narcos(router: router, watcher: watcher)
        return (watcher, router, scheduler)
    }
}
