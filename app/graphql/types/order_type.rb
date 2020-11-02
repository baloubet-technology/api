module Types
  class OrderType < Types::BaseObject
    field :id, ID, null: true
    field :quantity, Integer, null: true
    field :price, Float, null: true
    field :price_cents, Integer, null: true
    field :shipping_price, Float, null: true
    field :shipping_price_cents, Integer, null: true
    field :rate_product, Float, null: true
    field :rate_organization, Float, null: true
    field :fees, Float, null: true
    field :status, String, null: true
    field :tracking_url, String, null: true
    field :tracking_code, String, null: true
    field :tracker_id, String, null: true
    field :shipping_label, String, null: true
    field :order_url, String, null: true
    field :order_status, Boolean, null: false
    field :transfer_status, Boolean, null: false
    field :refund_status, Boolean, null: false

    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false

    field :organization, OrganizationType, null: false
    field :variant, VariantType, null: false
    field :payment, PaymentType, null: false
    field :refund, [Types::RefundType], null: true
    field :transfer, [Types::TransferType], null: true
  end
end
