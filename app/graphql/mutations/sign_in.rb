module Mutations
  class SignIn < Mutations::BaseMutation
    argument :email, String, required: true
    argument :password, String, required: true

    field :member, Types::MemberType, null: false

    def resolve(args)
      member = Member.find_for_database_authentication(email: args[:email])

      case member.present?
      when true

        case member.valid_password?(args[:password])
        when true

          context[:current_member] = member
          MutationResult.call(obj: { member: member }, success: true)
        when false
          GraphQL::ExecutionError.new('Incorrect Email/Password')
        end
      when false
        GraphQL::ExecutionError.new('Member not registered on this application')
      else
        GraphQL::ExecutionError.new('Not authorize')
      end
    end
  end
end
