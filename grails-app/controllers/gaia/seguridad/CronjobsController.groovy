package gaia.seguridad

import grails.plugins.quartz.QuartzMonitorJobFactory
import org.quartz.CronTrigger
import org.quartz.Scheduler
import org.quartz.Trigger
import org.quartz.TriggerKey
import org.quartz.impl.matchers.GroupMatcher

import static org.quartz.impl.matchers.GroupMatcher.jobGroupEquals

class CronjobsController {
    Scheduler quartzScheduler
    static final Map<String, Trigger> triggers = [:]
    def index() {
        def jobsList = []
        def listJobGroups = quartzScheduler.jobGroupNames
        listJobGroups?.each {jobGroup ->
            quartzScheduler.getJobKeys(jobGroupEquals(jobGroup))?.each {jobKey ->
                def jobName = jobKey.name
                def descripcion = Class.forName(jobKey.name).newInstance().descripcion
                List<Trigger> triggers = quartzScheduler.getTriggersOfJob(jobKey)
                if (triggers) {
                    triggers.each {trigger ->
                        def currentJob = createJob(jobGroup, jobName, jobsList, trigger.key.name,descripcion)
                        currentJob.trigger = trigger
                        def state = quartzScheduler.getTriggerState(trigger.key)
                        currentJob.triggerStatus = Trigger.TriggerState.find {
                            it == state
                        } ?: "UNKNOWN"
                    }
                } else {
                    createJob(jobGroup, jobName, jobsList,descripcion)
                }
            }
        }
//        println "list "+jobsList
//        jobsList.each {
//            println "job -> "+it
//        }
        [jobs: jobsList, now: new Date(), scheduler: quartzScheduler]

    }

    private createJob(String jobGroup, String jobName, List jobsList, String triggerName = "",String descripcion) {
        def currentJob = [group: jobGroup, name: jobName,descripcion:descripcion]
        def map = QuartzMonitorJobFactory.jobRuns[triggerName]
        if (map) currentJob << map
        jobsList << currentJob
        return currentJob
    }

    def stop = {
        def triggerKeys = quartzScheduler.getTriggerKeys(GroupMatcher.triggerGroupEquals(params.triggerGroup))
        def key = triggerKeys?.find {it.name == params.triggerName}
        if (key) {
            def trigger = quartzScheduler.getTrigger(key)
            if (trigger) {
                triggers[params.jobName] = trigger
                quartzScheduler.unscheduleJob(key)
            } else {
                flash.message = "No trigger could be found for $key"
            }
        } else {
            flash.message = "No trigger key could be found for $params.triggerGroup : $params.triggerName"
        }
        redirect(action: "index")
    }

    def start = {
        def trigger = triggers[params.jobName]
        if (trigger) {
            quartzScheduler.scheduleJob(trigger)
        } else {
            flash.message = "No trigger could be found for $params.jobName"
        }
        redirect(action: "index")
    }

    def pause = {
        def jobKeys = quartzScheduler.getJobKeys(GroupMatcher.jobGroupEquals(params.jobGroup))
        def key = jobKeys?.find {it.name == params.jobName}
        if (key) {
            quartzScheduler.pauseJob(key)
        } else {
            flash.message = "No job key could be found for $params.jobGroup : $params.jobName"
        }
        redirect(action: "index")
    }

    def resume = {
        def jobKeys = quartzScheduler.getJobKeys(GroupMatcher.jobGroupEquals(params.jobGroup))
        def key = jobKeys?.find {it.name == params.jobName}
        if (key) {
            quartzScheduler.resumeJob(key)
        } else {
            flash.message = "No job key could be found for $params.jobGroup : $params.jobName"
        }
        redirect(action: "index")
    }

    def runNow = {
        def jobKeys = quartzScheduler.getJobKeys(GroupMatcher.jobGroupEquals(params.jobGroup))
        def key = jobKeys?.find {it.name == params.jobName}
        if (key) {
            quartzScheduler.triggerJob(key)
        } else {
            flash.message = "No job key could be found for $params.jobGroup : $params.jobName"
        }
        redirect(action: "index")
    }

    def startScheduler = {
        quartzScheduler.start()
        redirect(action: "index")
    }

    def stopScheduler = {
        quartzScheduler.standby()
        redirect(action: "index")
    }

    def editCronTrigger = {
        def trigger = quartzScheduler.getTrigger(new TriggerKey(params.triggerName, params.triggerGroup))
        if (!(trigger instanceof CronTrigger)) {
            flash.message = "This trigger is not a cron trigger"
            redirect(action: "index")
            return
        }
        [trigger: trigger]
    }

    def saveCronTrigger = {
        if (!params.triggerName || !params.triggerGroup) {
            flash.message = "Invalid trigger parameters"
            redirect(action: "index")
            return
        }

        CronTrigger trigger = quartzScheduler.getTrigger(new TriggerKey(params.triggerName, params.triggerGroup)) as CronTrigger
        if (!trigger) {
            flash.message = "No such trigger"
            redirect(action: "index")
            return
        }

        try {
            trigger.cronExpression = params.cronexpression
            quartzScheduler.rescheduleJob(new TriggerKey(params.triggerName, params.triggerGroup), trigger)
        } catch (Exception ex) {
            flash.message = "cron expression (${params.cronexpression}) was not correct: $ex"
            render(view: "editCronTrigger", model: [trigger: trigger])
            return
        }
        redirect(action: "index")
    }


}
