module Types
  class ConnectType < Types::BaseObject
    field :id, ID, null: false
    field :key, String, null: false

    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false

    field :organization, OrganizationType, null: false
    field :software, SoftwareType, null: false
  end
end
