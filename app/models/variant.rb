class Variant < ApplicationRecord
  before_update :change_quantity

  has_many :order, dependent: :destroy
  belongs_to :organization
  belongs_to :product

  validates :sku, uniqueness: true, presence: true
  validates :price, presence: true
  validates :price_cents, presence: true
  validates :picture_url, uniqueness: true, presence: true

  validates :product_id, presence: true
  validates :organization_id, presence: true

  private

  def change_quantity
    case quantity_changed?
    when true

      case self.status
      when 'Live', 'Offline'

        case self.quantity
        when 0
          self.status = 'Offline'
        else
          self.status = 'Live'
        end
      end
    end
  end
end
