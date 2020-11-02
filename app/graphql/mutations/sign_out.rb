module Mutations
  class SignOut < Mutations::BaseMutation

    field :member, Types::MemberType, null: false

    def resolve
      member = context[:current_member]

      case member.present?
      when true
        success = member.reset_authentication_token!

        MutationResult.call(
          obj: { member: member },
          success: success,
          errors: member.errors
        )
      when false
        GraphQL::ExecutionError.new('Organization not signed in')
      else
        GraphQL::ExecutionError.new('Not authorize')
      end
    end
  end
end
