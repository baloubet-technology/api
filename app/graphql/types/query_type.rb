module Types
  class QueryType < Types::BaseObject

    field :all_brands, [Types::BrandType], null: false

    field :categories, [Types::CategoryType], null: false

    field :all_tags, [Types::TagType], null: false

    field :all_packages, [Types::PackageType], null: false

    field :softwares, [Types::SoftwareType], null: false

    field :mccs, [Types::MccType], null: false

    field :products, [Types::ProductType], null: false

    field :variants, [Types::VariantType], null: false do
      argument :id, ID, required: true
    end

    ############################################################################

    field :all_products, [Types::ProductType], null: false

    field :all_variants, [Types::VariantType], null: false

    field :all_orders, [Types::OrderType], null: false

    field :all_connects, [Types::ConnectType], null: false

    ############################################################################

    field :productId, Types::ProductType, null: false do
      argument :id, ID, required: true
    end

    field :variantId, Types::VariantType, null: false do
      argument :id, ID, required: true
    end

    field :orderId, Types::OrderType, null: false do
      argument :id, ID, required: true
    end

    field :connectId, Types::ConnectType, null: false do
      argument :id, ID, required: true
    end

    ############################################################################

    field :product, Types::ProductType, null: false do
      argument :id, ID, required: true
    end

    field :variant, Types::VariantType, null: false do
      argument :id, ID, required: true
    end

    field :tag, Types::TagType, null: false do
      argument :id, ID, required: true
    end

    field :brand, Types::BrandType, null: false do
      argument :id, ID, required: true
    end

    field :category, Types::CategoryType, null: false do
      argument :id, ID, required: true
    end

    field :package, Types::PackageType, null: false do
      argument :id, ID, required: true
    end

    field :software, Types::SoftwareType, null: false do
      argument :id, ID, required: true
    end

    field :mcc, Types::MccType, null: false do
      argument :id, ID, required: true
    end

    ############################################################################

    field :search_payment, Types::PaymentType, null: false do
      argument :charge, String, required: true
    end

    ############################################################################

    def search_payment(args)
      Payment.find_by(charge: args[:charge])
    end

    ############################################################################


    def brands
      Brand.all
    end

    def categories
      Category.all
    end

    def tags
      Tag.all
    end

    def packages
      Package.all
    end

    def softwares
      Software.all
    end

    def mccs
      Mcc.all
    end

    def products
      Product.where(status: 'Live')
    end

    def variants(args)
      Variant.where(product_id: args[:id], status: 'Live')
    end


    ############################################################################


    def all_products
      member = context[:current_member]
      product = Product.where(organization_id: member.organization_id)
    end

    def all_variants
      member = context[:current_member]
      variant = Variant.where(organization_id: member.organization_id)
    end

    def all_orders
      member = context[:current_member]
      order = Order.where(organization_id: member.organization_id)
      order.reverse_order
    end

    def all_connects
      member = context[:current_member]
      connect = Connect.where(organization_id: member.organization_id)
    end

    ############################################################################

    def productId(args)
      product = Product.find(args[:id])
      member = context[:current_member]

      if product.organization_id == member.organization_id
        return product
      else
        GraphQL::ExecutionError.new("Not authorize")
      end
    end

    def variantId(args)
      variant = Variant.find(args[:id])
      member = context[:current_member]

      if variant.organization_id == member.organization_id
        return variant
      else
        GraphQL::ExecutionError.new("Not authorize")
      end
    end

    def orderId(args)
      order = Order.find(args[:id])
      member = context[:current_member]

      if order.organization_id == member.organization_id
        return order
      else
        GraphQL::ExecutionError.new("Not authorize")
      end
    end

    def connectId(args)
      connect = Connect.find(args[:id])
      member = context[:current_member]

      if connect.organization_id == member.organization_id
        return connect
      else
        GraphQL::ExecutionError.new("Not authorize")
      end
    end

    ############################################################################


    def product(args)
      Product.where(status: 'Live', id: args[:id])
    end

    def variant(args)
      Variant.where(status: 'Live', id: args[:id])
    end

    def tag(args)
      Tag.find(args[:id])
    end

    def brand(args)
      Brand.find(args[:id])
    end

    def category(args)
      Category.find(args[:id])
    end

    def package(args)
      Package.find(args[:id])
    end

    def software(args)
      Software.find(args[:id])
    end

    def mcc(args)
      Mcc.find(args[:id])
    end
  end
end
