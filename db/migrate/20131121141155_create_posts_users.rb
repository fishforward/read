class CreatePostsUsers < ActiveRecord::Migration
  def change
    create_table :posts_users do |t|
      t.integer :post_id, :null => false
      t.integer :user_id, :null => false

    end
  end
end
