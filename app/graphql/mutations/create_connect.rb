module Mutations
  class CreateConnect < Mutations::BaseMutation
    argument :key, String, required: true
    argument :software_id, Integer, required: true

    field :connect, Types::ConnectType, null: true
    field :errors, [String], null: false

    def resolve(args)
      member = context[:current_member]

      case member.organization.status
      when true

        connect = Connect.create(
          key: args[:key],
          software_id: args[:software_id],
          organization_id: member.organization_id
        )

        if connect.save
          {
            connect: connect,
            errors: [],
          }
        else
          {
            connect: nil,
            errors: connect.errors.full_messages,
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
