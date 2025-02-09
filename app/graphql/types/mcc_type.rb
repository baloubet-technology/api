module Types
  class MccType < Types::BaseObject
    field :id, ID, null: false
    field :name, String, null: false
    field :code, String, null: false

    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false

    field :organization, [Types::OrganizationType], null: true
  end
end
