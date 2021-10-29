class CreateAppointments < ActiveRecord::Migration[6.1]
  def change
    create_table :appointments do |t|
      t.integer   :status, default: 0
      t.integer   :dose, default: 0
      t.datetime  :date
      t.datetime  :last_dose_date
      t.integer   :vaccine
      t.belongs_to :user_patient

      t.timestamps
    end
  end
end
