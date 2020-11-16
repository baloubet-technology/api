module Mutations
  class CreateProduct < Mutations::BaseMutation
    argument :name, String, required: true
    argument :description, String, required: true
    argument :brand_id, Integer, required: true
    argument :tag_id, Integer, required: true
    argument :package_id, Integer, required: true
    argument :quantity, Integer, required: true
    argument :price, Float, required: true
    argument :size, String, required: false
    argument :color, String, required: false
    argument :picture_url, String, required: false

    field :product, Types::ProductType, null: true
    field :errors, [String], null: false

    def resolve(args)
      member = context[:current_member]

      case member.organization.status
      when true

        stripe_product = Stripe::Product.create({
          name: args[:name],
          type: 'good',
          active: true,
          description: args[:description]
        })

        product = Product.create!(
          name: args[:name],
          description: args[:description],
          stripe_product: stripe_product.id,
          brand_id: args[:brand_id],
          tag_id: args[:tag_id],
          package_id: args[:package_id],
          organization_id: member.organization_id
        )

        stripe_sku = Stripe::SKU.create({
          active: true,
          price: (args[:price] * 100).to_i,
          currency: 'eur',
          inventory: {
            type: 'finite',
            quantity: args[:quantity]
          },
          product: stripe_product.id,
        })

        Cloudinary::Uploader.upload(args[:picture_url], :public_id => stripe_sku.id)

        variant = Variant.create(
          sku: stripe_sku.id,
          quantity: args[:quantity],
          price: args[:price],
          price_cents: (args[:price] * 100).to_i,
          size: args[:size],
          color: args[:color],
          picture_url: "https://res.cloudinary.com/baloubet/image/upload/v1590084125/#{stripe_sku.id}.png",
          product_id: product.id,
          organization_id: member.organization_id
        )

        if product.save
          {
            product: product,
            errors: [],
          }
        else
          {
            product: nil,
            errors: product.errors.full_messages,
          }
        end
      when false
        GraphQL::ExecutionError.new('You are not authorized, your account is being validated')
      else
        GraphQL::ExecutionError.new('Not authorize')
      end
    end
  end
end
