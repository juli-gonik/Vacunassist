class UserVacunator < User
  
  validates :dni, presence: true
  validates :dni, uniqueness: true
  validates :dni, numericality: { only_integer: true, greater_than_or_equal_to: 1_000_000, allow_blank: true }
  
  
  has_many :appointments, dependent: :destroy
  belongs_to :vacunatorio
end
