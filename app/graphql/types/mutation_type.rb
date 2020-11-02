module Types
  class MutationType < Types::BaseObject
    field :register_organization, mutation: Mutations::RegisterOrganization
    field :sign_in, mutation: Mutations::SignIn
    field :sign_out, mutation: Mutations::SignOut

    ############################################################################

    field :create_connect, mutation: Mutations::CreateConnect
    field :create_product, mutation: Mutations::CreateProduct
    field :create_variant, mutation: Mutations::CreateVariant
    field :create_payment, mutation: Mutations::CreatePayment
    field :create_order, mutation: Mutations::CreateOrder
    field :create_refund, mutation: Mutations::CreateRefund

    ############################################################################

    field :update_product, mutation: Mutations::UpdateProduct
    field :update_variant, mutation: Mutations::UpdateVariant
    field :update_organization, mutation: Mutations::UpdateOrganization

    ############################################################################

    field :destroy_product, mutation: Mutations::DestroyProduct
    field :destroy_variant, mutation: Mutations::DestroyVariant
  end
end
