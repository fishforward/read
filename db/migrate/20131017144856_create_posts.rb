class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
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

      t.integer :yes
      t.integer :no
      t.integer :pv

      t.timestamps
    end

    add_index :posts, :status
    add_index :posts, :author_id
    add_index :posts, :created_at
    add_index :posts, :id
    #add_index :posts, :msg_id, unique: true

  end
end
