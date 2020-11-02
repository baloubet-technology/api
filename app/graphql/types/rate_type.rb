module Types
  class RateType < Types::BaseObject
    field :id, ID, null: false
    field :country_code, String, null: false
    field :R000, Float, null: false
    field :R001, Float, null: true
    field :R002, Float, null: true
    field :R003, Float, null: true
    field :R004, Float, null: true
    field :R005, Float, null: true

    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false

    field :organization, [Types::OrganizationType], null: true
  end
end
