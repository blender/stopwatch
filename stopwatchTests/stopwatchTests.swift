//
//  stopwatchTests.swift
//  stopwatchTests
//
//  The MIT License (MIT)
//
//  Copyright (c) <2015> <Tommaso Piazza>
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

import UIKit
import XCTest
import stopwatch

class stopwatchTests: XCTestCase {
    
    var defaultStopWatch:StopWatch!
    
    override func setUp() {
        defaultStopWatch = StopWatch(name:"default")
    }
    
    func testThatAnEventIsStarted() {
        // This is an example of a functional test case.
        
        let event = self.defaultStopWatch.startEvent("A")
        XCTAssert(event.state == .Started, "Event was not started")
    }
    
    func testThatAnEventIsStopped() {
        
        self.defaultStopWatch.startEvent("A")
        if let event = self.defaultStopWatch.stopEvent("A") {
            
            XCTAssert(event.state == .Stopped, "Event was not stopped")
        }
        else {
        
            XCTFail("There was no event to stop")
        }
    }
    
    func testThatAnEventIsRestarted() {
        
        self.defaultStopWatch.startEvent("A")
        if let event = self.defaultStopWatch.restartEvent("A") {
            XCTAssert(event.state == .Started, "Event was not restarted")
        }
        else {
            
            XCTFail("There was no event to restart")
        }
    }
    
    func testThatAnEventIsRemoved() {
    
        self.defaultStopWatch.startEvent("A")
        if let event = self.defaultStopWatch.removeEvent("A") {
            XCTAssert(event.state == .Started, "Event was removed")
        }
        else {
            
            XCTFail("There was no event to remove")
        }
    }
    
    func testThatAllEventsAreRemoved() {
        
        self.defaultStopWatch.startEvent("A")
        self.defaultStopWatch.startEvent("B")
        self.defaultStopWatch.startEvent("C")
        self.defaultStopWatch.startEvent("D")
        
        XCTAssert(defaultStopWatch.events.count == 4, "There were not 4 events in the StopWatch")
        
        self.defaultStopWatch.removeAllEvents()
        
        XCTAssert(defaultStopWatch.events.count == 0, "There are still some events in the StopWatch")
    }
    
    func testThatAnEventsThatWasNeverStartedIsNotStopped () {
    
        if let event = self.defaultStopWatch.stopEvent("A") {
            
            XCTFail("An event that was never started, was stopped")

        }
        else {
            XCTAssertTrue(true, "")
        }
    }
    
    func testThatAnEventThatWasNeverStartedIsNotRestarted() {
    
        if let event = self.defaultStopWatch.restartEvent("A") {
            
            XCTFail("An event that was never started, was restarted")
            
        }
        else {
            XCTAssertTrue(true, "")
        }
    }
    
    func testThatStartTimeIsLowerThanStopTime() {
    
        let eventAtStart =  self.defaultStopWatch.startEvent("A")
        let startTime = eventAtStart.startTime
        
        NSThread.sleepForTimeInterval(0.1)
        
        let eventAtStop = self.defaultStopWatch.stopEvent("A")
        let stopTime = eventAtStart.stopTime
        
        XCTAssertTrue(startTime < stopTime, "Event start time is after event stop time")
    }
}
