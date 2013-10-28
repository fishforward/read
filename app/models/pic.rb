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

end
