namespace :scheduler_score do

	task :score => :environment do
	    puts "score start..."
	    Source.update_all_source_score
	    puts "done."
	end

end


