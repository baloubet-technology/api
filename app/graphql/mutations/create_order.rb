module Mutations
  class CreateOrder < Mutations::BaseMutation
    argument :variant_id, Integer, required: true
    argument :quantity, Integer, required: true
    argument :payment_id, Integer, required: true

    field :order, Types::OrderType, null: true
    field :errors, [String], null: false

    def resolve(args)
      variant = Variant.find(args[:variant_id])

      case variant.status
      when 'Live'
        price_cents = (variant.price_cents * args[:quantity]).to_i
        price = price_cents / 100

        order = Order.create(
          quantity: args[:quantity],
          price: price,
          price_cents: price_cents,
          variant_id: args[:variant_id],
          organization_id: variant.organization_id,
          payment_id: args[:payment_id]
        )

        if order.save
          {
            order: order,
            errors: [],
          }
        else
          {
            order: nil,
            errors: order.errors.full_messages
          }
        end
      else
        GraphQL::ExecutionError.new('Unable to purchase this product')
      end
    end
  end
end
