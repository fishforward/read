class CreatePics < ActiveRecord::Migration
  def change
    create_table :pics do |t|
      t.integer :post_id
      t.integer :order
      t.string :old_link
      t.string :link
      t.string :keypic

      t.timestamps
    end
  end
end
