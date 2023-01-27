class ApplicationMailer < ActionMailer::Base
  layout "mailrobot"

  default from: "No Reply <lcyc@members.lcyc.info>", reply_to: "lcyc@members.lcyc.info"
  default date: proc { Time.now.localtime }
end
