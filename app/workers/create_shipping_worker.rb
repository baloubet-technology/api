class CreateShippingWorker
  include Sidekiq::Worker
  sidekiq_options queue: :default, retry: 1

  def perform(order_id)
    order = Order.find(order_id)

    to_address = EasyPost::Address.create(
      :name => order.payment.name,
      :street1 => order.payment.line1,
      :city => order.payment.city,
      :zip => order.payment.postal_code,
      :country => order.payment.country,
      :phone => order.payment.phone,
      :email => order.payment.email
    )

    from_address = EasyPost::Address.create(
      :company => order.organization.name,
      :street1 => order.organization.line1,
      :city => order.organization.city,
      :zip => order.organization.postal_code,
      :country => order.organization.country,
      :phone => order.organization.phone,
      :email => order.organization.email
    )

    parcel = EasyPost::Parcel.create(
      :width => order.variant.product.package.width,
      :length => order.variant.product.package.length,
      :height => order.variant.product.package.height,
      :weight => order.variant.product.package.weight
    )

    customs_item = EasyPost::CustomsItem.create(
      :description => order.variant.product.name,
      :quantity => order.quantity,
      :value => order.price,
      :weight => order.variant.product.package.weight,
      :origin_country => order.organization.country,
      :code => order.variant.sku,
      :hs_tariff_number => order.variant.product.tag.category.hs_tariff_number
    )

    customs_info = EasyPost::CustomsInfo.create(
      :customs_certify => true,
      :customs_signer => order.payment.name,
      :contents_type => 'merchandise',
      :contents_explanation => '',
      :eel_pfc => 'NOEEI 30.37(a)',
      :non_delivery_option => 'return',
      :restriction_type => 'none',
      :customs_items => customs_item
    )

    shipment = EasyPost::Shipment.create(
      :to_address => to_address,
      :from_address => from_address,
      :parcel => parcel,
      :reference => order.payment.charge,
      :carrier_accounts => 'ca_8bd8ea0f2ea246308276b6ee7ca10e66',
      :customs_info => customs_info
    )

    shipment.buy(
      :rate => shipment.lowest_rate,
      :insurance => order.price
    )

    shipment.label(
      :file_format => 'PDF',
      :label_size => '4x6'
    )

    case shipment.status
    when 'unknown'
      status = 'En attente'
    when 'pre_transit'
      status = 'En transit'
    when 'in_transit'
      status = 'En transit'
    when 'out_for_delivery'
      status = 'En cours de livraison'
    when 'delivered'
      status = 'Livré'
    when 'available_for_pickup'
      status = 'En cours de ramassage'
    when 'return_to_sender'
      status = "Retour à l'expéditeur"
    when 'failure'
      status = 'Échec de la livraison'
    when 'cancelled'
      status = 'livraison annulé'
    when 'error'
      status = 'Erreur'
    end

    shipping_price_cents = (order.variant.product.package.price_cents * order.quantity).to_i
    shipping_price = shipping_price_cents / 100

    rate_product = select_rate_product(order_id)

    order.update(
      fees: order.organization.fees,
      status: status,
      shipping_label: shipment.postage_label.label_pdf_url,
      shipping_price: shipping_price,
      shipping_price_cents: shipping_price_cents,
      tracking_url: shipment.tracker.public_url,
      tracking_code: shipment.tracker.tracking_code,
      tracker_id: shipment.tracker.id,
      order_url: "https://api.baloubet.com/orders/#{shipment.tracker.id}.pdf",
      order_status: true,
      rate_product: rate_product,
      rate_organization: order.organization.rate.rate_fees
    )

    variant = order.variant.quantity - order.quantity

    order.variant.update(
      quantity: variant
    )

    Stripe::SKU.update(
      order.variant.sku,
      inventory: {
        quantity: variant
      }
    )
  end
end
