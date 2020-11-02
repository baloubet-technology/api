class Order < ApplicationRecord
  has_many :refund
  has_many :transfer
  belongs_to :variant
  belongs_to :organization
  belongs_to :payment

  validates :quantity, presence: true
  validates :price, presence: true
  validates :price_cents, presence: true

  validates :variant_id, presence: true
  validates :payment_id, presence: true
  validates :organization_id, presence: true
end
