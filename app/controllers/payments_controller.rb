class PaymentsController < ApplicationController
  skip_before_action :verify_authenticity_token
  http_basic_authenticate_with name: ENV['POSTGRES_USERNAME'], password: ENV['POSTGRES_PASSWORD'], except: :show

  ##############################################################################

  def show
    @payment = Payment.find_by(charge: params[:charge])

    respond_to do |format|
      format.html
      format.pdf do
        render pdf: "Invoice No. #{@payment.id}",
        page_size: 'A4',
        template: 'payments/show.html.erb',
        layout: 'pdf.html',
        encoding: 'utf8',
        lowquality: true,
        zoom: 1,
        dpi: 75
      end
    end
  end

  ##############################################################################

  def source

  end

  ##############################################################################

  def charge
    result = params.fetch('data')
    webhook = result.fetch('object')

    sleep 5

    case webhook.fetch('object')
    when 'charge'
      @payment = Payment.find_by(charge: webhook.fetch('id'))

      case webhook.fetch('paid')
      when true

        @payment.order.each do |o|

          case o.order_status
          when false
            CreateShippingWorker.perform_async(o.id)
            SelectRateProductWorker.perform_async(o.id)
          end
        end

        mail = PaymentMailer.with(payment: @payment).success
        mail.deliver_later!(wait: 3.minute)
      when false

      end
    end
  end
end
