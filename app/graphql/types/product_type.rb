module Types
  class ProductType < Types::BaseObject
    field :id, ID, null: false
    field :name, String, null: true
    field :description, String, null: true
    field :stripe_product, String, null: true
    field :status, String, null: false

    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false

    field :organization, OrganizationType, null: true
    field :brand, BrandType, null: true
    field :tag, TagType, null: true
    field :package, PackageType, null: true
    field :variant, [Types::VariantType], null: true
  end
end
