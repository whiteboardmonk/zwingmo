class AddUserFields < ActiveRecord::Migration
  def self.up
    change_table :users do |t|
      t.string :latitude, :longitude
      t.integer :zomato_city_id
    end
  end

  def self.down
    change_table :users do |t|
      t.remove :latitude, :longitude, :zomato_city_id
    end
  end
end
