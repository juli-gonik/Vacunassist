class Vacunatorio < ApplicationRecord
  validates :zone, presence: true
  validates :place, presence: true

  has_many :user_patients

  enum zone: {
    municipalidad: 0,
    terminal: 1,
    cementerio: 2
  }
  
  def to_s
    zone.capitalize
  end
end
