module Types
  class VariantType < Types::BaseObject
    field :id, ID, null: false
    field :sku, String, null: false
    field :quantity, Integer, null: false
    field :price, Float, null: false
    field :price_cents, Integer, null: false
    field :size, String, null: false
    field :color, String, null: false
    field :picture_url, String, null: false
    field :status, String, null: false

    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false

    field :organization, OrganizationType, null: false
    field :product, ProductType, null: false
    field :order, [Types::OrderType], null: false
  end
end
