class Appointment < ApplicationRecord
  belongs_to :user_patient

  enum vaccine: {
    covid: 0,
    gripe: 1,
    fiebre_amarilla: 2
  }
end
