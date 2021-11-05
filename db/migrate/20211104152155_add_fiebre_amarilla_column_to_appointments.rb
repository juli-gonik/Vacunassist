class AddFiebreAmarillaColumnToAppointments < ActiveRecord::Migration[6.1]
  def change
    add_column :appointments, :fiebre_amarilla, :boolean
  end
end
