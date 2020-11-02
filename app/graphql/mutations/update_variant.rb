module Mutations
  class UpdateVariant < Mutations::BaseMutation
    argument :id, Integer, required: true
    argument :quantity, Integer, required: true
    argument :price, Float, required: true
    argument :size, String, required: false
    argument :color, String, required: false

    field :variant, Types::VariantType, null: true
    field :errors, [String], null: false

    def resolve(args)
      variant = Variant.find(args[:id])
      member = context[:current_member]

      case member.organization.status
      when true

        case variant.organization_id
        when member.organization_id

          Stripe::SKU.update(
            variant.sku,
            price: (args[:price] * 100).to_i,
            inventory: {
              quantity: args[:quantity]
            },
          )

          variant.update(
            quantity: args[:quantity],
            price: args[:price],
            price_cents: (args[:price] * 100).to_i,
            size: args[:size],
            color: args[:color]
          )

          if variant.save
            {
              variant: variant,
              errors: [],
            }
          else
            {
              variant: nil,
              errors: variant.errors.full_messages
            }
          end
        else
          GraphQL::ExecutionError.new('You are not authorized, this variant does not belong to your organization')
        end
      when false
        GraphQL::ExecutionError.new('You are not authorized, your account is being validated')
      else
        GraphQL::ExecutionError.new('Not authorize')
      end
    end
  end
end
