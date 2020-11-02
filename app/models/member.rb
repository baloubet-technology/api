class Member < ApplicationRecord
  belongs_to :organization
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :token_authenticatable

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :gender, presence: true
  validates :birthday, presence: true
  validates :city, presence: true
  validates :line1, presence: true
  validates :postal_code, presence: true
  validates :state, presence: true
  validates :country, presence: true
  validates :country_code, presence: true
  validates :percent_ownership, presence: true
  validates :email, uniqueness: true, presence: true

  validates :organization_id, presence: true
end
