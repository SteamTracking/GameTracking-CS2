"use strict";
/// <reference path="../csgo.d.ts" />
// this is a wrapper for $.Schedule() that eliminates the need to keep track of which jobs are finished, since calling $.CancelScheduled()
// on a finished job breaks panorama. Particularly useful when sequencing animation events using schedule offsets.
//
// Usage:
// Call Scheduler.Schedule( delay, func ), just as you would $.Schedule().
// Call Scheduler.Cancel() to cancel any jobs previously added. 
//
// Additionally, you can keep sets of jobs separate using an optional keyword, e.g.
// 
// Scheduler.Schedule( delay, func, 'LASERS' );
// Scheduler.Cancel( 'LASERS' );
//
var Scheduler;
(function (Scheduler) {
    // a keyword indexed array of jobs
    const oJobs = {};
    function Schedule(delay, fn, key = 'default') {
        if (!oJobs.hasOwnProperty(key))
            oJobs[key] = [];
        oJobs[key].push(Job(delay, fn, key));
    }
    Scheduler.Schedule = Schedule;
    function Cancel(key = 'default') {
        if (oJobs.hasOwnProperty(key)) {
            while (oJobs[key].length) {
                const job = oJobs[key].pop();
                job.Cancel();
            }
        }
    }
    Scheduler.Cancel = Cancel;
    function Job(delay, func, key) {
        let m_handle = $.Schedule(delay, function () {
            m_handle = null; // we null it out first in case the func will try to clear out all jobs
            func();
            // $.Msg( 'SCHED: running\t', m_handle, '\t', key  );
        });
        // $.Msg( 'SCHED: adding\t', m_handle, ' \t', key );
        return {
            GetHandle: () => m_handle,
            Cancel: () => {
                if (m_handle) {
                    // $.Msg( 'SCHED: cancelling\t', m_handle, '\t', key );
                    $.CancelScheduled(m_handle);
                    m_handle = null;
                }
            },
        };
    }
})(Scheduler || (Scheduler = {}));
