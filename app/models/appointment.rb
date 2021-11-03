class Appointment < ApplicationRecord
  belongs_to :user_patient

  validate :dose_one_date

  validates :last_dose_date, presence: true, if: -> { vaccine == 'gripe' }

  enum vaccine: {
    covid: 0,
    gripe: 1,
    fiebre_amarilla: 2
  }

  def dose_one_date
    return unless vaccine == 'covid' && (dose == 1 || dose == 2)

    errors.add(:last_dose_date, :blank)
  end
end
