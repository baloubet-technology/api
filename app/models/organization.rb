class Organization < ApplicationRecord
  has_many :member
  has_many :connect
  has_many :product
  has_many :variant
  has_many :order
  has_many :refund
  has_many :transfer
  belongs_to :mcc
  belongs_to :rate

  validates :name, uniqueness: true, presence: true
  validates :country, presence: true
  validates :country_code, presence: true
  validates :city, presence: true
  validates :line1, presence: true
  validates :postal_code, presence: true
  validates :state, presence: true
  validates :email, uniqueness: true, presence: true
  validates :phone, uniqueness: true, presence: true
  validates :tax_id, uniqueness: true, presence: true
  validates :vat_id, uniqueness: true, presence: true
  validates :recipient, uniqueness: true, presence: true
  validates :business_name, uniqueness: true, presence: true
  validates :business_description, presence: true
  validates :organization_url, uniqueness: true, presence: true
  validates :currency, presence: true
  validates :fees, presence: true

  validates :mcc_id, presence: true
end
