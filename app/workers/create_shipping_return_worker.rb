class CreateShippingReturnWorker
  include Sidekiq::Worker
  sidekiq_options queue: :default, retry: 1

  def perform(refund_id)
    refund = Refund.find(refund_id)

    to_address = EasyPost::Address.create(
      :name => refund.order.payment.name,
      :street1 => refund.order.payment.line1,
      :city => refund.order.payment.city,
      :zip => refund.order.payment.postal_code,
      :country => refund.order.payment.country,
      :phone => refund.order.payment.phone,
      :email => refund.order.payment.email
    )

    from_address = EasyPost::Address.create(
      :company => refund.order.organization.name,
      :street1 => refund.order.organization.line1,
      :city => refund.order.organization.city,
      :zip => refund.order.organization.postal_code,
      :country => refund.order.organization.country,
      :phone => refund.order.organization.phone,
      :email => refund.order.organization.email
    )

    parcel = EasyPost::Parcel.create(
      :width => refund.order.variant.product.package.width,
      :length => refund.order.variant.product.package.length,
      :height => refund.order.variant.product.package.height,
      :weight => refund.order.variant.product.package.weight
    )

    customs_item = EasyPost::CustomsItem.create(
      :description => refund.order.variant.product.name,
      :quantity => refund.order.quantity,
      :value => refund.order.price,
      :weight => refund.order.variant.product.package.weight,
      :origin_country => refund.order.organization.country,
      :code => refund.order.variant.sku,
      :hs_tariff_number => refund.order.variant.product.tag.category.hs_tariff_number
    )

    customs_info = EasyPost::CustomsInfo.create(
      :customs_certify => true,
      :customs_signer => refund.order.payment.name,
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
      :reference => refund.order.payment.charge,
      :carrier_accounts => 'ca_8bd8ea0f2ea246308276b6ee7ca10e66',
      :customs_info => customs_info,
      :is_return => true
    )

    shipment.buy(
      :rate => shipment.lowest_rate,
      :insurance => refund.order.price
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

    refund.update(
      status: status,
      shipping_label: shipment.postage_label.label_pdf_url,
      tracking_url: shipment.tracker.public_url,
      tracking_code: shipment.tracker.tracking_code,
      tracker_id: shipment.tracker.id
    )

    mail = PaymentMailer.with(refund: refund.id).refund
    mail.deliver_now
  end
end
