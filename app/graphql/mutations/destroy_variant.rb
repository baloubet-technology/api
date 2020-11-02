module Mutations
  class DestroyVariant < Mutations::BaseMutation
    argument :id, Integer, required: true

    field :variant, Types::VariantType, null: true
    field :errors, [String], null: false

    def resolve(args)
      variant = Variant.find(args[:id])
      member = context[:current_member]

      case member.organization.status
      when true

        case variant.organization_id
        when member.organization_id

          Stripe::SKU.delete(variant.sku)

          variant.destroy

          if variant.destroy
            {
              variant: nil,
              errors: [],
            }
          else
            {
              variant: variant,
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
