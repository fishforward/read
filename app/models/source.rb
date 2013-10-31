require 'nokogiri'
require "utils/upyun"

class Source < ActiveRecord::Base
  attr_accessible :site_id, :site_name, :author_id, :author_name, :post_date, :title, :content, :text_content, :pic_url, :post_url, :status, :pv, :comment, :transmit, :love, :adjust, :score

  # 计算所有source的分值
  def self.update_all_source_score
    page = 1      
    sources = Source.where(:status=>'W').paginate(:page => page, :per_page => 20, :order => 'updated_at desc')

    while sources && !sources.empty?
      Source.update_score(sources)

      page++
      sources = Source.where(:status=>'W').paginate(:page => page, :per_page => 20, :order => 'updated_at desc')
    end
  end

  # 计算sources的分值
  def self.update_score(sources)
    sources.each do |source|
      puts "=========="+source.site_name+'--'+source.id.to_s+"--"+source.title+"--"+source.post_url
      site = Site.find(source.site_id)

      doc = Nokogiri::HTML(open(source.post_url))
      if doc == nil
        puts "doc is nil"
        next
      end
      puts doc.inspect

      #site.pv_tag
      pv = doc.at_css('#\\$_spaniReadCount')  if site.pv_tag && !site.pv_tag.blank?
      comment = doc.at_css(site.comment_tag).text  if site.comment_tag && !site.comment_tag.blank?
      transmit = doc.at_css(site.transmit_tag).text  if site.transmit_tag && !site.transmit_tag.blank?
      love = doc.at_css(site.love_tag).text  if site.love_tag && !site.love_tag.blank?

      source.pv = (pv && !pv.blank?) ? pv.to_i : 0
      source.comment = (comment && !comment.blank?) ? comment.to_i : 0
      source.transmit = (transmit && !transmit.blank?) ? transmit.to_i : 0 
      source.love = (love && !love.blank?) ? love.to_i : 0
      source.adjust = 0
      source.score = 0
      source.save
    end
  end

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

  	source.text_content = ActionController::Base.helpers.strip_tags(source.content)
  	source.post_url = item.link
  	source.status = 'W'
  	source.save

    source.content,source.pic_url = Source.upload(source)
    source.save

  	return source
  end

  def self.del_css(content)
  	html = Nokogiri::HTML(content)

  	arr = ['div','p','span','a','img','pre','font']
  	arr.each do |tag|
	  	html.css(tag).each do |h|
	  		h[:style]=""
	  	end
  	end
  	return html.css("body").to_s
  end


  def self.upload(source)
    content = source.content

  	html = Nokogiri::HTML(content)

  	#图片上传
    first_img = ''
  	html.css("img").each_with_index do |image,i|
      img = image[:src]

      puts img
      img_name = Uuid.get()
      UpYun.new().upload(img,img_name)
      new_img = FILE_PATH_PRE + img_name + '!middle'

      Pic.create(source, img, new_img, i)

      #puts new_img
      content = content.sub(img, new_img)
      first_img = new_img.sub('!middle','') if i==0
  	end

  	return content, first_img
  end

end
