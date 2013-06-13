SuckerPunch.config do
  queue name: :mailer_job, worker: MailerJob, workers: 3
  queue name: :sms_job,    worker: SMSJob,    workers: 5
end
