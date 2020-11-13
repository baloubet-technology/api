module Mutations
  class CreateVariant < Mutations::BaseMutation
    argument :quantity, Integer, required: true
    argument :price, Float, required: true
    argument :size, String, required: false
    argument :color, String, required: false
    argument :picture_url, String, required: false
    argument :product_id, Integer, required: true

    field :variant, Types::VariantType, null: true
    field :errors, [String], null: false

    def resolve(args)
      product = Product.find(args[:product_id])
      member = context[:current_member]

      case member.organization.status
      when true

        case product.organization_id
        when member.organization_id

          stripe_sku = Stripe::SKU.create({
            active: true,
            price: (args[:price] * 100).to_i,
            currency: 'eur',
            inventory: {
              type: 'finite',
              quantity: args[:quantity]
            },
            product: product.stripe_product,
          })

          variant = Variant.create(
            sku: stripe_sku.id,
            quantity: args[:quantity],
            price: args[:price],
            price_cents: (args[:price] * 100).to_i,
            size: args[:size],
            color: args[:color],
            picture_url: args[:picture_url],
            product_id: args[:product_id],
            organization_id: member.organization_id
          )

          if variant.save
            {
              variant: variant,
              errors: [],
            }
          else
            {
              variant: nil,
              errors: variant.errors.full_messages,
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
