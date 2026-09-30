"use strict";
/// <reference path="../csgo.d.ts" />
var Scheduler;
(function (Scheduler) {
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
            m_handle = null;
            func();
        });
        return {
            GetHandle: () => m_handle,
            Cancel: () => {
                if (m_handle) {
                    $.CancelScheduled(m_handle);
                    m_handle = null;
                }
            },
        };
    }
})(Scheduler || (Scheduler = {}));
