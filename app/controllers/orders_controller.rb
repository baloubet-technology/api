class OrdersController < ApplicationController
  skip_before_action :verify_authenticity_token
  http_basic_authenticate_with name: ENV['POSTGRES_USERNAME'], password: ENV['POSTGRES_PASSWORD'], except: :show

  ##############################################################################

  def show
    @order = Order.find_by(tracker_id: params[:tracker_id])

    fees = get_fees(@order.fees)

    @commission_ttc = get_commission_ttc(@order.price, fees)
    @commission_tva = get_commission_tva(@commission_ttc, @order.rate_organization)
    @commission_ht = get_commission_ht(@commission_ttc, @commission_tva)
    @total_du = get_total_du(@order.price, @commission_ttc)

    tva_product = get_ht_product(@order.variant.price, @order.rate_product)
    @total_product_ht = get_total_ht(@order.variant.price, tva_product)

    respond_to do |format|
      format.html
      format.pdf do
        render pdf: "Invoice No. #{@order.id}",
        page_size: 'A4',
        template: 'orders/show.html.erb',
        layout: 'pdf.html',
        encoding: 'utf8',
        lowquality: true,
        zoom: 1,
        dpi: 75
      end
    end
  end

  ##############################################################################

  def webhooks
    result = params.fetch('result')

    case result.fetch('object')
    when 'Tracker'

      case result.fetch('is_return')
      when false
        order = Order.find_by(tracker_id: result.fetch('id'))

        case result.fetch('status')
        when 'pre_transit'
          status = 'En transit'
        when 'in_transit'
          status = 'En transit'
        when 'out_for_delivery'
          status = 'En cours de livraison'
        when 'delivered'
          status = 'Livré'
          CreateTransferWorker.perform_in(5.minutes, order.id)
        when 'available_for_pickup'
          status = 'En cours de ramassage'
        when 'return_to_sender'
          status = "Retour à l'expéditeur"
        when 'failure'
          status = 'Échec de la livraison'
        when 'cancelled'
          status = 'Livraison annulé'
        when 'error'
          status = 'Erreur'
        end

        order.update(
          status: status
        )
      when true
        refund = Refund.find_by(tracker_id: result.fetch('id'))

        case result.fetch('status')
        when 'pre_transit'
          status = 'En transit'
        when 'in_transit'
          status = 'En transit'
        when 'out_for_delivery'
          status = 'En cours de livraison'
        when 'delivered'
          status = 'Livré'
          UpdateVariantAndRefundWorker.perform_async(refund.id)
        when 'available_for_pickup'
          status = 'En cours de ramassage'
        when 'return_to_sender'
          status = "Retour à l'expéditeur"
        when 'failure'
          status = 'Échec de la livraison'
        when 'cancelled'
          status = 'Livraison annulé'
        when 'error'
          status = 'Erreur'
        end

        refund.update(
          status: status
        )
      end
    end
  end

  private

  def get_fees(fees)
    v_fees = fees / 100
  end

  def get_commission_ttc(price, fees)
    v_commission_ttc = price * fees
  end

  def get_commission_tva(ttc, vat)
    v_commission_tva = ttc * (vat / 100)
  end

  def get_commission_ht(ttc, vat)
    v_commission_ht = ttc - vat
  end

  def get_total_du(price, ttc)
    v_total_du = price - ttc
  end

  def get_ht_product(variant_price, vat)
    v_ht_product = variant_price * (vat / 100)
  end

  def get_total_ht(variant_price, ht_product)
    v_total_ht = variant_price - ht_product
  end
end
