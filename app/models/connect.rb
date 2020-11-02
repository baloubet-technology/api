class Connect < ApplicationRecord
  belongs_to :organization
  belongs_to :software

  validates :key, uniqueness: true, presence: true

  validates :organization_id, presence: true
  validates :software_id, presence: true
end
