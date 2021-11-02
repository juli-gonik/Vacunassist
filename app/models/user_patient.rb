class UserPatient < User
  validates :birth_date, :dni, presence: true
  validates :risk_patient, inclusion: [true, false]
  validates :risk_patient, exclusion: [nil]
  validates :dni, uniqueness: true
  validates :dni, numericality: { only_integer: true, greater_than_or_equal_to: 1_000_000, allow_blank: true }

<<<<<<< HEAD
  has_many :appointments, dependent: :destroy
  validates_associated :appointments
=======
  has_many :appointments, dependent: :destroy, index_errors: true

  accepts_nested_attributes_for :appointments
>>>>>>> commit

  belongs_to :vacunatorio

<<<<<<< HEAD
  accepts_nested_attributes_for :appointments

  require 'date'

  def age
    now = Time.now.utc.to_date
    now.year - birth_date.year - ((now.month > birth_date.month || (now.month == birth_date.month && now.day >= birth_date.day)) ? 0 : 1)
  end
=======
>>>>>>> commit
end
