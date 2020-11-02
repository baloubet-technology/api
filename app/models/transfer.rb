class Transfer < ApplicationRecord
  belongs_to :order
  belongs_to :organization

  validates :amount, presence: true
  validates :amount_cents, presence: true
  validates :fees, presence: true
  validates :stripe_transfer, uniqueness: true, presence: true

  validates :organization_id, presence: true
  validates :order_id, presence: true
end
