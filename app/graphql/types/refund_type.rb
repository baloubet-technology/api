module Types
  class RefundType < Types::BaseObject
    field :id, ID, null: false
    field :refund_price, Float, null: true
    field :refund_price_cents, Integer, null: true
    field :shipping_price, Float, null: true
    field :shipping_price_cents, Integer, null: true
    field :tracking_url, String, null: true
    field :tracking_code, String, null: true
    field :tracker_id, String, null: true
    field :shipping_label, String, null: true
    field :stripe_refund, String, null: true
    field :status, String, null: true

    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false

    field :order, OrderType, null: false
    field :organization, OrganizationType, null: false
  end
end
