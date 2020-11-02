class UpdateVariantAndRefundWorker
  include Sidekiq::Worker
  sidekiq_options queue: :default, retry: 1

  def perform(refund_id)
    refund = Refund.find(refund_id)
    order = Order.find(refund.order_id)

    case order.transfer_status
    when false

      case order.refund_status
      when true

        case refund.stripe_refund.blank?
        when true

          quantity = order.quantity + order.variant.quantity

          order.variant.update(
            quantity: quantity,
          )

          Stripe::SKU.update(
            order.variant.sku,
            inventory: {
              quantity: quantity
            }
          )

          total = refund.refund_price - (4 * refund.refund_price / 100)

          stripe_refund = Stripe::Refund.create({
            charge: order.payment.charge,
            amount: (total * 100).to_i,
            reason: 'requested_by_customer',
          })

          refund.update(
            stripe_refund: stripe_refund.id
          )
        when false
          fail 'The variant and the reimbursement have already been made'
        end
      when false
        fail 'Unable to perform this action, the refund has not been requested'
      end
    when true
      fail 'Unable to perform the action, the transfer has been done'
    end
  end
end
