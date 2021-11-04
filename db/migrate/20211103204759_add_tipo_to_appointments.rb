class AddTipoToAppointments < ActiveRecord::Migration[6.1]
  def change
    add_column :appointments, :tipo, :integer
  end
end
