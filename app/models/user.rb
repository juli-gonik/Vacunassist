class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  validates :name, :last_name, :email, presence: true
  validates :password, presence: true, on: :create
  validates :password, confirmation: true, on: :create, unless: -> { password.blank? }

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable

end
