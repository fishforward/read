# encoding: utf-8

require 'rss/2.0'
require 'open-uri'

class Author < ActiveRecord::Base
  attr_accessible :name, :pic_url, :status, :last_pub_date, :default_type

  has_many :posts, :order => "created_at DESC"

  def self.create_by_name(name)
  	author = Author.new
  	author.name = name
  	author.status = "Y"
  	author.save
  	return author
  end


  def self.feed_rss
  	puts "====rss feed==="
  	#now_date = Time.new.strftime("%F")

  	authors = Author.all
  	authors.each do |author|

  		## 这里需要两个字段，一个是作者的blog url 另外一个是rss url
  		feed = RSS::Parser.parse(open(author.pic_url).read, false)
  		puts "#{feed.channel.title}"
  		puts feed.channel.title

  		last_time_str = nil
  		feed.items.reverse_each do |item|

  			if item.pubDate.strftime("%Y%m%d%H%M%S") <= author.last_msg_id
  				puts "continue";
  				next
  			end

			source = Source.new
			source.author_id = author.id
			source.post_date = item.pubDate.strftime("%F")
			source.title = item.title
			source.content = item.description
			#source.text_content
			source.post_url = item.link
			source.status = 'W'
			source.save

			last_time_str = item.pubDate.strftime("%Y%m%d%H%M%S")
		end

		## 这里需要一个”最后文章时间”字段
		author.last_msg_id = last_time_str  if last_time_str
		author.save
  	end

  end

end
