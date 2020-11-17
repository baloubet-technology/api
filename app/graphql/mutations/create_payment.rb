module Mutations
  class CreatePayment < Mutations::BaseMutation
    argument :name, String, required: true
    argument :email, String, required: true
    argument :phone, String, required: true
    argument :line1, String, required: true
    argument :city, String, required: true
    argument :postal_code, String, required: true
    argument :state, String, required: true
    argument :country, String, required: true
    argument :country_code, String, required: true
    argument :amount_cents, Integer, required: true
    argument :card_number, String, required: true
    argument :exp_month, Integer, required: true
    argument :exp_year, Integer, required: true
    argument :cvc, String, required: true

    field :payment, Types::PaymentType, null: false
    field :errors, [String], null: false

    def resolve(args)
      stripe_token = Stripe::Token.create(
        card: {
          number: args[:card_number],
          exp_month: args[:exp_month],
          exp_year: args[:exp_year],
          name: args[:name],
          cvc: args[:cvc]
        },
      )

      stripe_source = Stripe::Source.create({
        type: 'card',
        currency: 'eur',
        owner: {
          email: args[:email],
          name: args[:name],
          phone: args[:phone],
          address: {
            city: args[:city],
            country: args[:country],
            line1: args[:line1],
            postal_code: args[:postal_code],
            state: args[:state],
          },
        },
        token: stripe_token,
      })

      #test_wechat = Stripe::Source.create({
      #  type: 'wechat',
      #  currency: 'eur',
      #  amount: 1099,
      #})

      stripe_charge = Stripe::Charge.create({
        amount: args[:amount_cents],
        currency: 'eur',
        source: stripe_source,
        capture: true,
        receipt_email: args[:email],
        shipping: {
          name: args[:name],
          address: {
            line1: args[:line1],
            city: args[:city],
            state: args[:state],
            postal_code: args[:postal_code],
            country: args[:country],
          }
        }
      })

      amount = args[:amount_cents].to_f / 100

      payment = Payment.create(
        name: args[:name],
        email: args[:email],
        phone: args[:phone],
        line1: args[:line1],
        city: args[:city],
        postal_code: args[:postal_code],
        state: args[:state],
        country: args[:country],
        country_code: args[:country_code],
        amount: amount,
        amount_cents: args[:amount_cents],
        charge: stripe_charge.id,
        payment_url: "https://api.baloubet.com/payments/#{stripe_charge.id}.pdf"
      )

      if payment.save
        {
          payment: payment,
          errors: [],
        }
      else
        {
          payment: nil,
          errors: payment.errors.full_messages,
        }
      end
    end
  end
end
