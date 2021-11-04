class Appointment < ApplicationRecord
  belongs_to :user_patient

  validate :dose_one_date

  enum vaccine: {
    covid: 0,
    gripe: 1,
    fiebre_amarilla: 2
  }

  enum status: {
    pending: 0,
    confirmed: 1,
    past: 2,
    not_valid: 3
  }

  enum tipo: {
    sistema: 0,
    pedido: 1
  }

  private

  def dose_one_date
    return unless vaccine == 'covid' && (dose == 1 || dose == 2) && tipo == 'sistema'

    errors.add(:last_dose_date, :blank) if last_dose_date.blank?
  end
end
