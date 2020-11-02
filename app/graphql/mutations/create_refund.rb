module Mutations
  class CreateRefund < Mutations::BaseMutation
    argument :tracker_id, String, required: true

    field :refund, Types::RefundType, null: true
    field :errors, [String], null: false

    def resolve(args)
      order = Order.find_by(tracker_id: args[:tracker_id])

      case order.transfer_status
      when false

        order.update(
          refund_status: true
        )

        refund_price_cents = order.price_cents - order.shipping_price_cents

        refund = Refund.create(
          refund_price: (refund_price_cents / 100),
          refund_price_cents: refund_price_cents,
          shipping_price: order.shipping_price,
          shipping_price_cents: order.shipping_price_cents,
          order_id: order.id,
          organization_id: order.organization_id
        )

        CreateShippingReturnWorker.perform_async(refund.id)

        if refund.save
          {
            refund: refund,
            errors: [],
          }
        else
          {
            refund: nil,
            errors: refund.errors.full_messages,
          }
        end
      when true
        GraphQL::ExecutionError.new('Not authorize')
      end
    end
  end
end
