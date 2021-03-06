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

  	source.text_content = ActionController::Base.helpers.strip_tags(source.content)
  	source.post_url = item.link
  	source.status = 'W'
  	source.save

    begin
      source.content,source.pic_url = Source.upload(source)
      source.save
    rescue StandardError => e

      puts "===== EXCEPTION ===image upload=="+e.inspect

      ## 删除垃圾数据
      Pic.delete_by_post_id(source.id)
      source.destory
      source = nil
    end 

  	return source
  end

  def self.del_css(content)
  	html = Nokogiri::HTML(content)

  	arr = ['div','p','span','a','img','pre','font']
  	arr.each do |tag|
	  	html.css(tag).each do |h|
	  		h[:style]="" if !h[:style].blank?
        h[:href]="javascript:void(0);" if !h[:href].blank?
        h[:class]=""  if !h[:class].blank?
        h[:target]=""  if !h[:target].blank?

        h[:width]=''  if !h[:width].blank?
        h[:height]=""  if !h[:height].blank?
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
      img = nil
      # sina图片特殊处理  如果有real_src 则赋值给src
      if source.post_url.include?('http://blog.sina.com.cn')
        img = image[:real_src]
        #puts img
        image[:src] = img if img && !img.blank?
        #puts image[:src]
      end
      img = image[:src]

      puts img
      if img && !img.blank?

        img_name = Uuid.get()
        #puts img_name
        UpYun.new().upload(img,img_name)
        new_img = FILE_PATH_PRE + img_name + '!middle'

        Pic.create(source, img, new_img, i)

        #puts new_img
        img = img.sub('&','&amp;') # 特殊符号替换
        content = content.sub(img, new_img)
        first_img = new_img.sub('!middle','') if i==0
  	  end
    end

  	return content, first_img
  end

end
