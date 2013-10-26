class CreateHistorysources < ActiveRecord::Migration
  def change
    create_table :historysources do |t|

      t.integer :site_id
      t.string :site_name
      t.integer :author_id
      t.string :author_name

      t.string :post_date
      t.string :title
      t.text   :content
      t.text   :text_content
      t.text   :pic_url
      t.text   :post_url
      t.string :status

      t.timestamps
    end

    add_index :historysources, :status
    add_index :historysources, :created_at
    add_index :historysources, :id
  end
end
