class Product < ApplicationRecord
  belongs_to :package
  belongs_to :tag
  belongs_to :brand
  belongs_to :organization
  has_many :variant, dependent: :destroy

  validates :name, presence: true
  validates :description, presence: true
  validates :stripe_product, uniqueness: true, presence: true

  validates :tag_id, presence: true
  validates :brand_id, presence: true
  validates :organization_id, presence: true
  validates :package_id, presence: true
end
