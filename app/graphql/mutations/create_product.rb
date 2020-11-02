module Mutations
  class CreateProduct < Mutations::BaseMutation
    argument :name, String, required: true
    argument :description, String, required: true
    argument :brand_id, Integer, required: true
    argument :tag_id, Integer, required: true
    argument :package_id, Integer, required: true

    field :product, Types::ProductType, null: true
    field :errors, [String], null: false

    def resolve(args)
      member = context[:current_member]

      case member.organization.status
      when true

        stripe_product = Stripe::Product.create({
          name: args[:name],
          type: 'good',
          active: true,
          description: args[:description],
        })

        product = Product.create!(
          name: args[:name],
          description: args[:description],
          stripe_product: stripe_product.id,
          brand_id: args[:brand_id],
          tag_id: args[:tag_id],
          package_id: args[:package_id],
          organization_id: member.organization_id
        )

        if product.save
          {
            product: product,
            errors: [],
          }
        else
          {
            product: nil,
            errors: product.errors.full_messages,
          }
        end
      when false
        GraphQL::ExecutionError.new('You are not authorized, your account is being validated')
      else
        GraphQL::ExecutionError.new('Not authorize')
      end
    end
  end
end
