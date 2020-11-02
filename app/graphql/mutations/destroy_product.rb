module Mutations
  class DestroyProduct < Mutations::BaseMutation
    argument :id, Integer, required: true

    field :product, Types::ProductType, null: true
    field :errors, [String], null: false

    def resolve(args)
      product = Product.find(args[:id])
      member = context[:current_member]

      case member.organization.status
      when true

        case product.organization_id
        when member.organization_id

          product.variant.each do |v|
            Stripe::SKU.delete(v.sku)
          end

          Stripe::Product.delete(product.product_stripe)

          product.destroy

          if product.destroy
            {
              product: nil,
              errors: [],
            }
          else
            {
              product: product,
              errors: product.errors.full_messages,
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
