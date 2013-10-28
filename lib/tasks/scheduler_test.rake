namespace :scheduler_test do

	desc "test"
	task :test_read_rss => :environment do
	    puts "test_read_rss start..."
	    Site.test_read_rss('http://meiwenrishang.com/rss')
	    puts "done."
	end

	task :test_read_html => :environment do
	    puts "test_read_html start..."
	    Site.test_read_html(4, 'http://bbs.sciencenet.cn/home.php?mod=space&uid=279992&do=blog&id=734141')
	    puts "done."
	end
end


