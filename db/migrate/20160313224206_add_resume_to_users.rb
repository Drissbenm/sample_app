class AddResumeToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :name, :string
    add_column :users, :attachment, :string
  end

  def self.down
    remove_column :users, :attachment
    remove_column :users, :name
  end
end
