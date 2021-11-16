class Certificate < ApplicationRecord
  belongs_to :appointment

  enum vaccine: {
    covid: 0,
    gripe: 1,
    fiebre_amarilla: 2
  }

  validates :observations, presence: true
  validates :vaccine, presence: true
  validates :dose, presence: true, if: -> { vaccine == 'covid' }
end
