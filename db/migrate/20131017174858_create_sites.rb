class CreateSites < ActiveRecord::Migration
  def change
    create_table :sites do |t|
      t.string :name
      t.string :status
      t.string :url
      t.string :auto_read
      t.string :read_url
      t.string :read_type
      t.string :last_pub_date 
      t.string :name_tag
      t.string :content_tag

      t.timestamps
    end
  end
end
