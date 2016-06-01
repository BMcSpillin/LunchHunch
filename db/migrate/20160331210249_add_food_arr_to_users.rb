class AddFoodArrToUsers < ActiveRecord::Migration
  def change
    add_column :users, :food_arr, :text
  end
end
