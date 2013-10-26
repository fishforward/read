require 'nokogiri'
require "utils/upyun"

class Source < ActiveRecord::Base
  attr_accessible :site_id, :site_name, :author_id, :author_name, :post_date, :title, :content, :text_content, :pic_url, :post_url, :status

  # 参数 site:网站对象, author:作者对象 item:rss里面单个文章对象 
  def self.create_wait_audit_source(site, item, content)

  	##TODO
  	# 这里看是否需要判断下url不能重复  或者 表上加唯一约束

    # 记录保存 
  	source = Source.new
  	source.site_id = site.id
  	source.site_name = site.name
  	#source.author_id = 
  	source.author_name = site.author

  	source.post_date = item.pubDate.strftime("%F")
  	source.title = item.title

  	if content
  		source.content = content
  	else
  		source.content = item.description
  	end
  	source.content = Source.del_css(source.content)
  	source.content = Source.upload(source.content)

  	source.text_content = ActionController::Base.helpers.strip_tags(source.content)
  	#source.pic_url
  	source.post_url = item.link
  	source.status = 'W'
  	source.save
  	return source
  end

  def self.del_css(content)
  	html = Nokogiri::HTML(content)

  	arr = ['div','p','span']
  	arr.each do |tag|
	  	html.css(tag).each do |h|
	  		h[:style]=""
	  	end
  	end
  	return html.css("body").to_s
  end


  def self.upload(content)

  	html = Nokogiri::HTML(content)

  	#图片上传

  	html.css("img").each do |image|
      img = image[:src]
      puts img
        img_name = Uuid.get()
        UpYun.new().upload(img,img_name)

        new_img = FILE_PATH_PRE + img_name + '!middle'
        #puts new_img
        content = content.sub(img, new_img)
  	end

  	return content
  end

end
