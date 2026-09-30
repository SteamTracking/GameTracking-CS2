"use strict";
/// <reference path="../csgo.d.ts" />
var Async;
(function (Async) {
    function Delay(fDelay, value) {
        return new Promise(resolve => $.Schedule(fDelay, () => resolve(value)));
    }
    Async.Delay = Delay;
    /**
     * Returns a `Promise` that will resolve during the next frame.
     */
    function NextFrame() {
        return Delay(0.0);
    }
    Async.NextFrame = NextFrame;
    /**
     * Returns a `Promise` that will resolve the next time the event with name `sEvent` is dispatched.
     * The resolve value is an array of the event parameters.
     */
    function UnhandledEvent(sEvent) {
        return new Promise(resolve => {
            const nHandlerId = $.RegisterForUnhandledEvent(sEvent, function (...args) {
                $.UnregisterForUnhandledEvent(sEvent, nHandlerId);
                resolve(args);
            });
        });
    }
    Async.UnhandledEvent = UnhandledEvent;
    /**
     * A controller object that allows you to abort any process observing the `signal` member.
     */
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
    /**
     * Runs the `sequenceFn`, awaiting the result of every yield, and not resuming the `sequenceFn` if `abortSignal` has aborted.
     * Returns a `Promise` that resolve `true` on completion or `false` if `abortSignal` was aborted.
     */
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
    /**
     * Utility class for scheduling relative to a point in time.
     * @example
     * const start = new TimeStamp();
     * await Async.Delay( 1 ); // Async.Delay is always relative to now
     * $.Msg( "1 second later" );
     * await start.Delay( 2 );
     * $.Msg( "2 seconds later" );
     * await start.Delay( 3 );
     * $.Msg( "3 seconds later" );
     */
    class TimeStamp {
        frameTime = $.FrameTime();
        /**
         * Schedule a function to be run later, relative to when this `TimeStamp` was created.
         */
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
