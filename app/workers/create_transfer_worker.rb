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

      fees = order.price_cents * (order.fees / 100)
      amount_cents = (order.price_cents - fees).to_i

      amount = amount_cents.to_f / 100

      stripe_transfer = Stripe::Transfer.create({
        amount: amount_cents,
        currency: 'eur',
        destination: order.organization.recipient,
        source_transaction: order.payment.charge
      })

      Transfer.create(
        amount: amount,
        amount_cents: amount_cents,
        fees: fees,
        stripe_transfer: stripe_transfer.id,
        organization_id: order.organization_id,
        order_id: order_id
      )
    else
      fail 'The transfer could not be completed'
    end
  end
end
