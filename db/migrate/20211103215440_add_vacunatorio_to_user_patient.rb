class AddVacunatorioToUserPatient < ActiveRecord::Migration[6.1]
  def change
    add_reference :users, :vacunatorio, index: true
    add_foreign_key :users, :vacunatorios
  end
end
