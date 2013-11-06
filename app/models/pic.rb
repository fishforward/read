class Pic < ActiveRecord::Base
  attr_accessible :keypic, :link, :old_link, :order, :post_id

  def self.create(source, old_link, link, order)
  	pic = Pic.new
  	pic.post_id = source.id
  	pic.order = order
  	pic.old_link = old_link
  	pic.link = link
  	pic.keypic = 'Y' if order == 0

  	pic.save
  end


  def self.delete_by_post_id(post_id)
    pics = Pic.find_all_by_post_id(post_id)
    pics.each do |pic|
      pic.destroy

      link = pic.link.sub("!middle",'').sub(FILE_PATH_PRE,'')
      UpYun.new().delete(link)
    end
  end

end
