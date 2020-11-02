module Types
  class PackageType < Types::BaseObject
    field :id, ID, null: false
    field :name, String, null: false
    field :length, Float, null: false
    field :width, Float, null: false
    field :height, Float, null: false
    field :weight, Float, null: false
    field :price, Float, null: false
    field :price_cents, Integer, null: false

    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false

    field :product, [Types::ProductType], null: false
  end
end
