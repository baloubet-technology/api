module Mutations
  class UpdateOrganization < Mutations::BaseMutation
    argument :email, String, required: true
    argument :phone, String, required: true
    argument :password, String, required: false
    argument :password_confirmation, String, required: false

    field :organization, Types::OrganizationType, null: false

    def resolve(args)
      member = context[:current_member]

      case member.valid_password?(args[:password])
      when true

        organization = member.organization.update(
          email: args[:email],
          phone: args[:phone],
        )

        if organization.save
          {
            organization: organization,
            errors: [],
          }
        else
          {
            organization: nil,
            errors: organization.errors.full_messages,
          }
        end
      when false
        GraphQL::ExecutionError.new('Incorrect your current password')
      else
        GraphQL::ExecutionError.new('Not authorize')
      end
    end
  end
end
