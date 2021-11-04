class Vacunatorio < ApplicationRecord
  validates :zone, presence: true

  has_many :user_patients

  enum zone: {
    municipalidad: 0,
    terminal:      1,
    cementerio:    2
  }
end
