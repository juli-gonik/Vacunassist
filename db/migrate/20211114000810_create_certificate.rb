class CreateCertificate < ActiveRecord::Migration[6.1]
  def change
    create_table :certificates do |t|
      t.string  :observations
      t.integer :vaccine
      t.integer :dose
      t.belongs_to :appointment

      t.timestamps
    end
  end
end
