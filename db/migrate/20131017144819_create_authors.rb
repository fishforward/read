class CreateAuthors < ActiveRecord::Migration
  def change
    create_table :authors do |t|
      t.string :name
      t.string :status
      t.string :pic_url
      t.string :last_pub_date
      t.string :default_type  #文章默认类型

      t.timestamps
    end

    add_index :authors, :name, unique: true
    add_index :authors, :id
  end
end
