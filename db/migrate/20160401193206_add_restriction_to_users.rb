class AddRestrictionToUsers < ActiveRecord::Migration
  def change
    add_column :users, :restriction, :string
  end
end
