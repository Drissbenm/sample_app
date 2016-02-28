class AddBirthdayToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :age, :datetime, :default => nil
  end

  def self.down
    remove_column :users, :age
  end
end
