//
//  StopWatch.swift
//  stopwatch
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

import Foundation


@objc public class StopWatch: NSObject {
    
    private (set) public var events = [String:StopWatchEvent]()
    public let name:String
    
    
    public init(name:String) {
        
        self.name = name
        super.init()
    }
    
    
    public func startEvent(name:String) -> StopWatchEvent {
        
        if let event = events[name] {
            
            event.internalState = .Started
            
            return event
        }
        else {
            
            let newEvent = StopWatchEvent(name: name)
            
            events[name] = newEvent
            newEvent.internalState = .Started
            
            return newEvent
        }
    }
    
    
    public func restartEvent(name:String) -> StopWatchEvent? {
        
        if let event = events[name] {
            
            event.internalState = .Stopped
            event.internalState = .Undefined
            event.internalState = .Started
            
            return event
        }
        return nil
    }
    
    public func stopEvent(name:String) -> StopWatchEvent? {
        
        if let event = events[name] {
            
            event.internalState = .Stopped
            
            return event
        }
        
        return nil
    }
    
    public func removeEvent(name:String) -> StopWatchEvent? {
        
        return events.removeValueForKey(name)
    }
    
    public func removeAllEvents() {
        
        events.removeAll(keepCapacity: true)
    }
}