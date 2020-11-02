module Types
  class TransferType < Types::BaseObject
    field :id, ID, null: false
    field :amount, Float, null: false
    field :amount_cents, Integer, null: false
    field :fees, Float, null: false
    field :stripe_transfer, String, null: false

    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false

    field :order, OrderType, null: false
    field :organization, OrganizationType, null: false
  end
end
