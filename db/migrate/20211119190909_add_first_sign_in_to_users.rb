class AddFirstSignInToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :first_sign_in, :boolean, default: false
  end
end
