class SelectRateProduct
  include Sidekiq::Worker
  sidekiq_options queue: :default, retry: 1

  def perform(order_id)
    order = Order.find(order_id)

    result = Rate.all

    rate = result.find do |res|
      res.fetch('id') == order.organization.rate_id
    end

    rate_product = rate.fetch(order.variant.product.tag.vat_code)

    order.update(
      rate_product: rate_product
    )
  end
end
