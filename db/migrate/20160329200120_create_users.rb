class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
    	t.string :location
    	t.string :allergies
    	t.boolean :weather
    	t.boolean :mood
    	t.boolean :healthy
    	t.boolean :spicy
    	t.boolean :price
    	


      t.timestamps null: false
    end
  end
end
