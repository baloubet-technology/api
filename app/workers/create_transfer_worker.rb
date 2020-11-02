class CreateTransferWorker
  include Sidekiq::Worker
  sidekiq_options queue: :default, retry: 1

  def perform(order_id)
    order = Order.find(order_id)

    case order.refund_status
    when false

      order.update(
        transfer_status: true
      )

      fees = order.price * (order.fees / 100)
      total = order.price - fees

      stripe_transfer = Stripe::Transfer.create({
        amount: (total * 100).to_i,
        currency: 'eur',
        destination: order.organization.recipient,
        source_transaction: order.payment.charge
      })

      Transfer.create(
        amount: total,
        fees: fees,
        stripe_transfer: stripe_transfer.id,
        organization_id: order.organization_id,
        order_id: order.id
      )
    else
      fail 'The transfer could not be completed'
    end
  end
end
