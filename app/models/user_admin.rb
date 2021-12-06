class UserAdmin < User
    validates :name, :last_name,presence: true
    validates :dni, presence: true
    validates :dni, uniqueness: true
    validates :dni, numericality: { only_integer: true, greater_than_or_equal_to: 1_000_000, allow_blank: true }

    devise authentication_keys: [:email, :access_key]
    #belongs_to :

end
  