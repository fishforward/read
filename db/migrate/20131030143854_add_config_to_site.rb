class AddConfigToSite < ActiveRecord::Migration
  def change
    add_column :sites, :pv_tag, :string
    add_column :sites, :comment_tag, :string
    add_column :sites, :transmit_tag, :string
    add_column :sites, :love_tag, :string
    add_column :sites, :replace_tag, :string
  end
end
