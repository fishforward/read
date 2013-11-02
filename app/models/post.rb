require 'rubygems'
require 'nokogiri'
require 'open-uri'
require "utils/upyun"

class Post < ActiveRecord::Base
  attr_accessible :site_id, :site_name, :author_id, :author_name, :content, :text_content, :pic_url, :post_date, :post_url, :status, :title, :yes, :no, :pv

  belongs_to :author

  acts_as_taggable

  acts_as_taggable_on :subjects
  
  def self.short_cut(posts)
  	if posts && posts.length > 0

      posts.each do |post|
        number = 260 + Random.rand(40)
        post.text_content = post.text_content[0,number] if post.text_content
      end
    end
    
    return posts
  end


  def self.fetch(id)

      authors = []
      if id != nil && id !='0'
        authors << Author.find(id)
      else
        authors = Author.find_all_by_status('Y')
      end
       
      authors.each do |author|
        begin

          if id != nil && id !='0' && author.id != id.to_i
            next
          end

          user_code = author.weixin_id
          msg_id_base = author.last_msg_id.to_i
          url_0 = "http://mp.weixin.qq.com/mp/appmsg/show?__biz="
          url_1 = "==&appmsgid="
          url_2 = "&itemidx="
          url_3 = "#wechat_redirect"

          1.upto(50) do |i|
            1.upto(5) do |j|
                msg_id = msg_id_base + i
                url = url_0 + user_code + url_1 + msg_id.to_s + url_2 + j.to_s + url_3

                puts "=========" + author.name + "========="+ msg_id.to_s + "=========" + j.to_s
                # 开始计算
                start_time = Time.now.tv_usec

                doc = Nokogiri::HTML(open(url))
                #puts doc.inspect

                # title 
                title = doc.at_css("title").text
                if title ==nil || title ==''
                  puts "not post"
                  next
                end
                old_post = Source.find_by_title_and_author_id(title, author.id)
                if old_post != nil
                  puts "already exist"
                  author.last_msg_id = msg_id
                  author.save
                  next
                end

                if  title && title.length > 0
                  #puts "~~~~~~" + doc.at_css("title").text

                  # time
                  date_str = ''
                  doc.css(".header").each do |item|
                    date_str = item.at_css("span").text
                    break
                  end

                  # content
                  content = ''
                  pic = ''
                  text_content = ''
                  doc.css(".page-content").each do |item|

                    # 正文  去除一些换行
                    content = item.at_css(".text").to_s
                    content = content.gsub('<p><br></p>','')
                    ## 这个没起作用 fuck
                    content = content.gsub('/<p.*><br><\/p>/','')

                    text_content = item.at_css(".text").text if item.at_css(".text")

                    #puts content
                    if item.at_css(".media img") 
                      pic = item.at_css(".media img")[:src]
                      #puts item.at_css(".media img")[:src]

                        ########## 上传图片 开始
                      #puts pic.split('/').inspect
                      pic_name = pic.split('/')[4]
                      #puts pic_name
                      UpYun.new().upload(pic,pic_name)
                      pic = FILE_PATH_PRE + pic_name
                    end

                    #内部图片
                    pre_link = "http://mmsns.qpic.cn"
                    item.css(".text img").each do |image|
                        img = image[:src]
                        puts img
                        if img && img.include?(pre_link)
                          img_name = img.split('/')[4]
                          UpYun.new().upload(img,img_name)

                          new_img = FILE_PATH_PRE + img_name + '!middle'
                          puts new_img
                          content = content.sub(img, new_img)
                        end
                    end
                    ########## 上传图片  结束
                  end
                  
                  # title 没重复的情况下新增一个
                  source = Source.new()
                  source.author_id = author.id
                  source.post_date = date_str 
                  source.msg_id = msg_id.to_s
                  source.title = title
                  source.content = content
                  source.text_content = text_content
                  source.pic_url = pic
                  source.post_url = url
                  source.status = 'A'
                  source.item = j.to_s
                  source.save

                  author.last_msg_id = msg_id
                  author.save

                  puts source.id.to_s + '----'+ source.msg_id.to_s

                end

                # 结束计算
                end_time = Time.now.tv_usec
                puts "msg: " + (end_time - start_time).to_s
            end
          end

        rescue Exception => e
          puts "rescue error:" + e.message
          puts "rescue error-more:" + e.backtrace.inspect 
        end
      end
  end


  def self.fetch_by_url(url)
    # 开始计算
    start_time = Time.now.tv_usec

    uri = URI.parse(url) 
    param_str =  uri.query
    puts param_str

    start = param_str.index('__biz=')
    author_code = param_str[start+6, 14]

    start = param_str.index('appmsgid=')
    msg_id = param_str[start+9, 8]

    start = param_str.index('itemidx=')
    j = param_str[start+8, 1]
    
    puts author_code
    puts msg_id
    puts j

    author = Author.find_by_weixin_id(author_code)
    puts author.inspect

    if author == nil
      puts "Author is not exist:" + author_code
      #return;
      newAuthor = Author.new
      newAuthor.name = author_code
      newAuthor.status = 'Y'
      newAuthor.weixin_id = author_code
      newAuthor.last_msg_id = msg_id
      newAuthor.save

      author = newAuthor
    end

    doc = Nokogiri::HTML(open(url))
    #puts doc.inspect

    # title 
    title = doc.at_css("title").text
    if title ==nil || title ==''
      puts "not post"
      return ;
    end
    old_post = Source.find_by_title_and_author_id(title, author.id)
    if old_post != nil
      puts "already exist"
      author.last_msg_id = msg_id
      author.save
      return ;
    end

    if  title && title.length > 0
      #puts "~~~~~~" + doc.at_css("title").text

      # time
      date_str = ''
      doc.css(".header").each do |item|
        date_str = item.at_css("span").text
        break
      end

      # content
      content = ''
      pic = ''
      text_content = ''
      doc.css(".page-content").each do |item|

        # 正文  去除一些换行
        content = item.at_css(".text").to_s
        content = content.gsub('<p><br></p>','')
        ## 这个没起作用 fuck
        content = content.gsub('/<p.*><br><\/p>/','')

        text_content = item.at_css(".text").text if item.at_css(".text")

        #puts content
        if item.at_css(".media img") 
          pic = item.at_css(".media img")[:src]
          #puts item.at_css(".media img")[:src]

            ########## 上传图片 开始
          #puts pic.split('/').inspect
          pic_name = pic.split('/')[4]
          #puts pic_name
          UpYun.new().upload(pic,pic_name)
          pic = FILE_PATH_PRE + pic_name
        end

        #内部图片
        pre_link = "http://mmsns.qpic.cn"
        item.css(".text img").each do |image|
            img = image[:src]
            puts img
            if img && img.include?(pre_link)
              img_name = img.split('/')[4]
              UpYun.new().upload(img,img_name)

              new_img = FILE_PATH_PRE + img_name + '!middle'
              puts new_img
              content = content.sub(img, new_img)
            end
        end
        ########## 上传图片  结束
      end
      
      # title 没重复的情况下新增一个
      source = Source.new()
      source.author_id = author.id
      source.post_date = date_str 
      source.msg_id = msg_id.to_s
      source.title = title
      source.content = content
      source.text_content = text_content
      source.pic_url = pic
      source.post_url = url
      source.status = 'A'
      source.item = j
      source.save

      author.last_msg_id = msg_id
      author.save

      puts source.id.to_s + '----'+ source.msg_id.to_s

    end

    # 结束计算
    end_time = Time.now.tv_usec
    puts "msg: " + (end_time - start_time).to_s
  end 


end
