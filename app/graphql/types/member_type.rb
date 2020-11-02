module Types
  class MemberType < Types::BaseObject
    field :id, ID, null: false
    field :first_name, String, null: false
    field :last_name, String, null: false
    field :gender, String, null: false
    field :birthday, String, null: false
    field :city, String, null: false
    field :line1, String, null: false
    field :postal_code, String, null: false
    field :state, String, null: false
    field :country, String, null: false
    field :country_code, String, null: false
    field :director, Boolean, null: false
    field :executive, Boolean, null: false
    field :owner, Boolean, null: false
    field :representative, Boolean, null: false
    field :percent_ownership, String, null: false
    field :email, String, null: false

    field :authentication_token, String, null: false
    field :authentication_token_created_at, GraphQL::Types::ISO8601DateTime, null: false

    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false

    field :organization, OrganizationType, null: false

    def authentication_token
      object.authentication_token
    end
  end
end
