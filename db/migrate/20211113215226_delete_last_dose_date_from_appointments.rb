class DeleteLastDoseDateFromAppointments < ActiveRecord::Migration[6.1]
  def change
    remove_column :appointments, :last_dose_date
  end
end
