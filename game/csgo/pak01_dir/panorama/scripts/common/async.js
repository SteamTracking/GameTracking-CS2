"use strict";
/// <reference path="../csgo.d.ts" />
var Async;
(function (Async) {
    function Delay(fDelay, value) {
        return new Promise(resolve => $.Schedule(fDelay, () => resolve(value)));
    }
    Async.Delay = Delay;
    function NextFrame() {
        return Delay(0.0);
    }
    Async.NextFrame = NextFrame;
    function UnhandledEvent(sEvent) {
        return new Promise(resolve => {
            const nHandlerId = $.RegisterForUnhandledEvent(sEvent, function (...args) {
                $.UnregisterForUnhandledEvent(sEvent, nHandlerId);
                resolve(args);
            });
        });
    }
    Async.UnhandledEvent = UnhandledEvent;
    class AbortController {
        signal;
        _aborted = false;
        constructor() {
            const controller = this;
            this.signal = { get aborted() { return controller._aborted; } };
        }
        abort() {
            this._aborted = true;
        }
    }
    Async.AbortController = AbortController;
    function Condition(predicate, abortSignal) {
        return new Promise(resolve => {
            (async function () {
                while (abortSignal === undefined || !abortSignal.aborted) {
                    if (predicate()) {
                        resolve();
                        return;
                    }
                    await NextFrame();
                }
            })();
        });
    }
    Async.Condition = Condition;
    function RunSequence(sequenceFn, abortSignal) {
        return new Promise(resolve => {
            (async function () {
                const generator = sequenceFn(abortSignal || new Async.AbortController().signal);
                let value;
                while (true) {
                    const iterResult = await generator.next(value);
                    if (iterResult.done) {
                        resolve(true);
                        return;
                    }
                    value = await iterResult.value;
                    if (abortSignal && abortSignal.aborted) {
                        resolve(false);
                        return;
                    }
                }
            })();
        });
    }
    Async.RunSequence = RunSequence;
    class TimeStamp {
        frameTime = $.FrameTime();
        Schedule(fDelay, fn) {
            const fDelayFromNow = fDelay - ($.FrameTime() - this.frameTime);
            $.Schedule(fDelayFromNow, fn);
        }
        Delay(fDelay, value) {
            return new Promise(resolve => this.Schedule(fDelay, () => resolve(value)));
        }
    }
    Async.TimeStamp = TimeStamp;
})(Async || (Async = {}));
