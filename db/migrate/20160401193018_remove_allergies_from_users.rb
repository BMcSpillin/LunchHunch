class RemoveAllergiesFromUsers < ActiveRecord::Migration
  def change
    remove_column :users, :allergies, :string
  end
end
