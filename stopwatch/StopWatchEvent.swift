//
//  StopWatchEvent.swift
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

public func ==(lhs: StopWatchEvent, rhs: StopWatchEvent) -> Bool {
    return lhs.name == rhs.name
}

public enum StopWatchEventState: Int {
    
    case Undefined = 0
    case Started
    case Stopped
}



@objc public class StopWatchEvent : NSObject, Equatable {

    static var s_timebase_info = mach_timebase_info(numer: 0, denom: 0)

    
    /**
    The name of the event.
    */
    public let name:String
    
    /**
    The time in milliseconds relative to device uptime when
    the event was started.
    */
    private (set) public var startTime:UInt = 0
    
    /**
    The time in milliseconds relative to device uptime when
    the event was stopped.
    */
    private (set) public var stopTime:UInt = 0
    
    
    /**
    The internal storage of the current state of the event.
    */
    private var _internalState:StopWatchEventState
    
    
    internal var internalState:StopWatchEventState {
        
        get {
            return self._internalState
        }
        set(newState) {
            
            switch newState {
            case .Undefined:
                self.startTime = UInt.max
                self.stopTime = UInt.max
                self._internalState = newState
            case .Started:
                switch self._internalState {
                case .Started:
                    println("Trying to start event: \(self.name), but \(self.name) was already started.")
                case .Stopped, .Undefined:
                    self.startTime = uptime()
                    self.stopTime = UInt.max
                    self._internalState = newState
                }
            case .Stopped:
                switch self._internalState {
                case .Undefined:
                    println("Trying to stop event: \(self.name), but \(self.name) was never started.")
                case .Stopped:
                    println("Trying to stop event: \(self.name), but \(self.name) was already stopped.")
                case .Started:
                    self.stopTime = uptime()
                    self._internalState = newState
                }
            }
        }
    
    }
    
    /**
    The current state of the event.
    */
    public var state:StopWatchEventState {
        
        return internalState
    }
    
    /**
    
    The elapsed time in milliseconds expressed as the difference between the stop time
    and the start time. Can be negative.

    */
    
    public var elapsedTime:Int {
        let result = self.stopTime-self.startTime
        return Int(result)
    }
    
    
    /**

    Initilised a new StopWatchEvent
    
    :param: name The name of the event
    
    */
    
    public init(name:String) {
        
        self.name = name
        self._internalState = .Undefined
        super.init()
        self.internalState = .Undefined
    }
    
    private func uptime()->UInt {
        
        let oneMillion:UInt64 = 1_000_000;
        if StopWatchEvent.s_timebase_info.denom == 0 {
            mach_timebase_info(&StopWatchEvent.s_timebase_info)
        }
        
        // mach_absolute_time() returns billionth of seconds,
        // so divide by one million to get milliseconds
        
        let abs_time = mach_absolute_time()
        let numer = UInt64(StopWatchEvent.s_timebase_info.numer)
        let denom = UInt64(StopWatchEvent.s_timebase_info.denom)
        
        let scaledTime = (abs_time * numer)
        let scale = (oneMillion * denom)
        let result =  Double(scaledTime) / Double(scale)
        
        return UInt(result)
    }
}