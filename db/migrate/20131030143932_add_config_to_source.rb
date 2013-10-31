class AddConfigToSource < ActiveRecord::Migration
  def change
    add_column :sources, :pv, :integer
    add_column :sources, :comment, :integer
    add_column :sources, :transmit, :integer
    add_column :sources, :love, :integer
    add_column :sources, :adjust, :integer
    add_column :sources, :score, :integer
  end
end
