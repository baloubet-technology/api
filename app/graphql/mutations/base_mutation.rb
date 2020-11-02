module Mutations
  class BaseMutation < GraphQL::Schema::RelayClassicMutation
    argument_class Types::BaseArgument
    field_class Types::BaseField
    input_object_class Types::BaseInputObject
    object_class Types::BaseObject

    field :success, Boolean, null: false
    field :errors, [String], null: true

    protected

    def authorize_member
      return true if context[:current_member].present?

      raise GraphQL::ExecutionError, "Member not signed in"
    end
  end
end
