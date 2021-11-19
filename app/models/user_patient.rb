class UserPatient < User
  validates :birth_date, :dni, presence: true
  #validates :risk_patient, inclusion: [true, false], unless: -> { current_user_vacunator }
  #validates :risk_patient, exclusion: [nil], unless: -> { current_user_vacunator }
  validates :dni, uniqueness: true
  validates :dni, numericality: { only_integer: true, greater_than_or_equal_to: 1_000_000, allow_blank: true }

  devise authentication_keys: [:email, :access_key]

  has_many :appointments, dependent: :destroy
  validates_associated :appointments

  accepts_nested_attributes_for :appointments

  belongs_to :vacunatorio

  accepts_nested_attributes_for :appointments

  require 'date'

  def age
    now = Time.now.utc.to_date
    now.year - birth_date.year - ((now.month > birth_date.month || (now.month == birth_date.month && now.day >= birth_date.day)) ? 0 : 1)
  end
end
