class Refund < ApplicationRecord
  belongs_to :order
  belongs_to :organization

  validates :refund_price, presence: true
  validates :refund_price_cents, presence: true
  validates :shipping_price, presence: true
  validates :shipping_price_cents, presence: true
  validates :stripe_refund, uniqueness: true, presence: true

  validates :order_id, presence: true
  validates :organization_id, presence: true
end
