module Types
  class SoftwareType < Types::BaseObject
    field :id, ID, null: false
    field :name, String, null: false

    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false

    field :connect, [Types::ConnectType], null: false
  end
end
