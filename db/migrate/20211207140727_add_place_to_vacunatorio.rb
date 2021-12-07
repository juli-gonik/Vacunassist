class AddPlaceToVacunatorio < ActiveRecord::Migration[6.1]
  def change
    add_column :vacunatorios, :place, :text
  end
end
