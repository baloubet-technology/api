module Types
  class PaymentType < Types::BaseObject
    field :id, ID, null: false
    field :name, String, null: false
    field :email, String, null: false
    field :phone, String, null: false
    field :line1, String, null: false
    field :city, String, null: false
    field :postal_code, String, null: false
    field :state, String, null: false
    field :country, String, null: false
    field :country_code, String, null: false
    field :amount, Float, null: false
    field :amount_cents, Integer, null: false
    field :charge, String, null: false
    field :payment_url, String, null: false

    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false

    field :order, [Types::OrderType], null: false
  end
end
