class AddFiebreAmarillaColumnToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :fiebre_amarilla, :boolean
  end
end
