class AddFilmLivreToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :nbr_film, :integer
    add_column :users, :livre, :boolean
  end

  def self.down
    remove_column :users, :livre
    remove_column :users, :nbr_film
  end
end
