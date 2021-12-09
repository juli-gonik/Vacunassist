class Appointment < ApplicationRecord
  belongs_to :user_patient
  has_one    :certificate
  has_one    :vacunatorio, through: :user_patient

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
    canceled: 3
  }

  enum tipo: {
    sistema: 0,
    pedido: 1
  }

  scope :today_appointments, lambda { |vacunatorio|
    joins(:user_patient).where(date: DateTime.current.midnight).pedido.where(user_patient: { vacunatorio: vacunatorio })
  }

  private

  def dose_one_date
    return unless vaccine == 'covid' && (dose == 1 || dose == 2) && tipo == 'sistema'

    errors.add(:date, :blank) if date.blank?
  end
end
