class SelectRateProductWorker
  include Sidekiq::Worker
  sidekiq_options queue: :default, retry: 1

  def perform(order_id)
    order = Order.find(order_id)

    rate = order.organization.rate

    result = rate.fetch(order.variant.product.tag.rate_code)

    order.update(
      rate_product: result
    )
  end
end
