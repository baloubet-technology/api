module Types
  class VariantType < Types::BaseObject
    field :id, ID, null: false
    field :sku, String, null: true
    field :quantity, Integer, null: true
    field :price, Float, null: true
    field :price_cents, Integer, null: true
    field :size, String, null: true
    field :color, String, null: true
    field :picture_url, String, null: true
    field :status, String, null: true

    field :created_at, GraphQL::Types::ISO8601DateTime, null: true
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: true

    field :organization, OrganizationType, null: true
    field :product, ProductType, null: true
    field :order, [Types::OrderType], null: true
  end
end
