module Mutations
  class UpdateProduct < Mutations::BaseMutation
    argument :id, Integer, required: true
    argument :name, String, required: true
    argument :description, String, required: true
    argument :brand_id, Integer, required: true
    argument :tag_id, Integer, required: true
    argument :package_id, Integer, required: true

    field :product, Types::ProductType, null: true
    field :errors, [String], null: false

    def resolve(args)
      product = Product.find(args[:id])
      member = context[:current_member]

      case member.organization.status
      when true

        case product.organization_id
        when member.organization_id

          Stripe::Product.update(
            product.product_stripe,
            name: args[:name],
            description: args[:description],
          )

          product.update(
            name: args[:name],
            description: args[:description],
            brand_id: args[:brand_id],
            tag_id: args[:tag_id],
            package_id: args[:package_id]
          )

          if product.save
            {
              product: product,
              errors: [],
            }
          else
            {
              product: nil,
              errors: product.errors.full_messages
            }
          end
        else
          GraphQL::ExecutionError.new('You are not authorized, this product does not belong to your organization')
        end
      when false
        GraphQL::ExecutionError.new('You are not authorized, your account is being validated')
      else
        GraphQL::ExecutionError.new('Not authorize')
      end
    end
  end
end
