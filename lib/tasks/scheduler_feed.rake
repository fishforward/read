namespace :scheduler_feed do

	desc "cron-feed"
	task :feed_rss => :environment do
	    puts "feed_rss start..."
	    Site.read_site
	    puts "done."
	end

end


