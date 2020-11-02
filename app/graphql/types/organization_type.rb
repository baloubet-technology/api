module Types
  class OrganizationType < Types::BaseObject
    field :id, ID, null: false
    field :name, String, null: false
    field :country, String, null: false
    field :country_code, String, null: false
    field :city, String, null: false
    field :line1, String, null: false
    field :postal_code, String, null: false
    field :state, String, null: false
    field :email, String, null: false
    field :phone, String, null: false
    field :tax_id, String, null: false
    field :vat_id, String, null: false
    field :recipient, String, null: false
    field :business_name, String, null: false
    field :business_description, String, null: false
    field :currency, String, null: false
    field :organization_url, String, null: false
    field :status, Boolean, null: false
    field :fees, Float, null: false

    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false

    field :mcc, MccType, null: false
    field :rate, RateType, null: false
    field :member, [Types::MemberType], null: false
    field :connect, [Types::ConnectType], null: false
    field :product, [Types::ProductType], null: false
    field :variant, [Types::VariantType], null: false
    field :order, [Types::OrderType], null: false
    field :refund, [Types::RefundType], null: true
    field :transfer, [Types::TransferType], null: true
  end
end
