class PaymentMailer < ApplicationMailer
  def success
    @payment = params[:payment]
    @orders = @payment.order.all
    attachments["#{@payment.charge}.pdf"] = WickedPdf.new.pdf_from_string(
      render_to_string(page_size: 'A4', pdf: 'payment', template: 'payments/show.html.erb', layout: 'pdf.html', encoding: "utf8", lowquality: true, zoom: 1, dpi: 75)
    )

    mail(
      to: @payment.email,
      subject: "Merci de votre achat!"
    )
  end

  def refund
    @refund = Refund.find(params[:refund])

    @order = Order.find(@refund.order_id)

    mail(
      to: @order.payment.email,
      subject: "Remboursement de votre achat!"
    )
  end
end
