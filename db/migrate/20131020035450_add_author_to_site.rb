class AddAuthorToSite < ActiveRecord::Migration
  def change
    add_column :sites, :author, :string
  end
end
