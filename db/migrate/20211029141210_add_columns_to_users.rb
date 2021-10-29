class AddColumnsToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :name, :string
    add_column :users, :last_name, :string
    add_column :users, :dni, :integer
    add_column :users, :access_key, :string
    add_column :users, :birth_date, :datetime
    add_column :users, :zone, :integer
    add_column :users, :risk_patient, :boolean
    add_index  :users, :dni,                unique: true
  end
end
