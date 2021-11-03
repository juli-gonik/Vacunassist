class UserPatient < User
  validates :birth_date, :dni, :zone, :risk_patient, presence: true
  validates :risk_patient, inclusion: [true, false]
  validates :risk_patient, exclusion: [nil]
  validates :dni, uniqueness: true
  validates :dni, numericality: { only_integer: true, greater_than_or_equal_to: 1_000_000, allow_blank: true }

  has_many :appointments, dependent: :destroy
  validates_associated :appointments

  enum zone: {
    municipalidad: 0,
    terminal:      1,
    cementerio:    2
  }

  accepts_nested_attributes_for :appointments

  require 'date'

  def age
    now = Time.now.utc.to_date
    now.year - birth_date.year - ((now.month > birth_date.month || (now.month == birth_date.month && now.day >= birth_date.day)) ? 0 : 1)
  end
end
