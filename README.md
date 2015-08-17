# stopwatch
A quick time profiling utility framework.

## What is stopwatch
Sometimes you just want to have an idea of how long some code takes to execute, without firing up Instruments and using the time profiler.

Stopwatch does just that. Read more about the motivations behinde it at [http://allocinit.io/ios/timing-function-execution-stopwatch/](http://allocinit.io/ios/timing-function-execution-stopwatch/).

## Usage
* Create a StopWatch
* Start an event
* call function
* Stop event
* Log execution time (in milliseconds)

Example:

```swift
let stopWatch = StopWatch(name:"SleepingBeauty")

stopWatch.startEvent("Sleeping")
                        
for i in 0...10000 {
    usleep(10)
}

let event = stopWatch.stopEvent("Sleeping")
println(event?.elapsedTime)

```


