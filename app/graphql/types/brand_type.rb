module Types
  class BrandType < Types::BaseObject
    field :id, ID, null: false
    field :name, String, null: false

    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false

    field :product, [Types::ProductType], null: true
  end
end
