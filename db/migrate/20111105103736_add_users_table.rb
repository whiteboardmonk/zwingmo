class AddUsersTable < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :name, :first_name, :last_name, :location, :location_id, :gender, :facebook_access_token, :email
      t.integer :facebook_uid
    end
    add_index :users, :facebook_uid
  end

  def self.down
    remove_table :users
  end
end
