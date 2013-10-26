desc "This task is called by the Heroku scheduler add-on"
task :fetch => :environment do
    puts "go fetch..."
    SendMailer.notify_email(nil).deliver
    Post.fetch(nil)
    SendMailer.notify_email(nil).deliver
    puts "done."
end