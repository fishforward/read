class SendMailer < ActionMailer::Base
  default from: "from@example.com"

  def notify_email(contentMap)
  	puts "mail start"
    @contentMap = contentMap

    mail to: 'fishgyuyi@gmail.com', subject: 'There is once fetch from webchat.'
    #puts "mail end"
  end
end
