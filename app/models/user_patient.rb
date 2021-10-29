class UserPatient < User
  validates :birth_date, :dni, :zone, :risk_patient, presence: true
  validates :dni, uniqueness: true
  validates :dni, numericality: { only_integer: true, greater_than_or_equal_to: 1_000_000, allow_blank: true }

  has_many :appointments, dependent: :destroy

  enum zone: {
    municipalidad: 0,
    terminal:      1,
    cementerio:    2
  }

  accepts_nested_attributes_for :appointments
end
