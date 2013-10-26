namespace :scheduler_test do

	desc "test"
	task :test_read_rss => :environment do
	    puts "test_read_rss start..."
	    Site.test_read_rss('http://feed.feedsky.com/chuangyihuabao')
	    puts "done."
	end

	task :test_read_html => :environment do
	    puts "test_read_html start..."
	    Site.test_read_html(9, 'http://mistory.info/?p=775')
	    puts "done."
	end
end


