class Payment < ApplicationRecord
  has_many :order

  validates :name, presence: true
  validates :email, presence: true
  validates :phone, presence: true
  validates :line1, presence: true
  validates :city, presence: true
  validates :postal_code, presence: true
  validates :state, presence: true
  validates :country, presence: true
  validates :country_code, presence: true
  validates :amount, presence: true
  validates :amount_cents, presence: true
  validates :charge, uniqueness: true, presence: true
  validates :payment_url, uniqueness: true, presence: true
end
