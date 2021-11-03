class CreateVacunatorios < ActiveRecord::Migration[6.1]
  def change
    create_table :vacunatorios do |t|
      t.integer   :zone

      t.timestamps
    end
  end
end
