class SelectRateProductWorker
  include Sidekiq::Worker
  sidekiq_options queue: :default, retry: 1

  def perform(order_id)
    order = Order.find(order_id)

    rate = Rate.find(order.organization.rate_id)
    rate_hash = rate.as_json

    result = rate_hash.fetch(order.variant.product.tag.rate_code)

    order.update(
      rate_product: result
    )
  end
end
