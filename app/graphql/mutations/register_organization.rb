module Mutations
  class RegisterOrganization < Mutations::BaseMutation
    argument :email, String, required: true
    argument :name, String, required: true
    argument :country, String, required: true

    argument :country_code, String, required: true

    argument :city, String, required: true
    argument :line1, String, required: true
    argument :postal_code, String, required: true
    argument :state, String, required: true
    argument :phone, String, required: true
    argument :tax_id, String, required: true
    argument :vat_id, String, required: true
    argument :business_name, String, required: true
    argument :business_description, String, required: true
    argument :organization_url, String, required: true

    argument :mcc_id, Integer, required: true

    argument :bank_account_country, String, required: true
    argument :bank_account_currency, String, required: true

    argument :bank_account_holder_name, String, required: true
    argument :bank_account_number, String, required: true

    argument :person_first_name, String, required: true
    argument :person_last_name, String, required: true
    argument :person_email, String, required: true
    argument :person_bd, String, required: true
    argument :person_bm, String, required: true
    argument :person_by, String, required: true
    argument :person_city, String, required: true
    argument :person_country, String, required: true
    argument :person_country_code, String, required: true
    argument :person_line1, String, required: true
    argument :person_postal_code, String, required: true
    argument :person_state, String, required: true
    argument :person_gender, String, required: true
    argument :percent_ownership, String, required: true
    argument :password, String, required: true

    argument :director, Boolean, required: false
    argument :executive, Boolean, required: false
    argument :owner, Boolean, required: false
    argument :representative, Boolean, required: false

    field :member, Types::MemberType, null: false

    def resolve(args)
      mcc = Mcc.find(args[:mcc_id])

      organization_country_code = args[:country_code].upcase

      # Création d'un token qui contient les infos d'une organizations
      stripe_token_account = Stripe::Token.create({
        account: {
          business_type: 'company',
          company: {
            address: {
              city: args[:city],
              country: organization_country_code,
              line1: args[:line1],
              postal_code: args[:postal_code],
              state: args[:state],
            },
            directors_provided: true,
            executives_provided: true,
            name: args[:name],
            owners_provided: true,
            phone: args[:phone],
            tax_id: args[:tax_id],
            vat_id: args[:vat_id],
          },
          tos_shown_and_accepted: true,
        },
      })

      # Création du compte de l'organization avec réutilisation du stripe_token_account
      stripe_create_account = Stripe::Account.create({
        type: 'custom',
        country: organization_country_code,
        email: args[:email],
        requested_capabilities: [
          'transfers',
        ],
        account_token: stripe_token_account,
        business_profile: {
          mcc: mcc.code,
          name: args[:business_name],
          product_description: args[:business_description],
          support_email: args[:email],
          support_phone: args[:phone],
          url: args[:organization_url]
        },
      })

      person_country_code = args[:person_country_code].upcase

      # Création d'un token qui contient les infos de la personne qui enregistre l'organization
      stripe_token_person = Stripe::Token.create({
        person: {
          first_name: args[:person_first_name],
          last_name: args[:person_last_name],
          email: args[:person_email],
          dob: {
            day: args[:person_bd],
            month: args[:person_bm],
            year: args[:person_by],
          },
          address: {
            city: args[:person_city],
            country: person_country_code,
            line1: args[:person_line1],
            postal_code: args[:person_postal_code],
            state: args[:person_state],
          },
          gender: args[:person_gender],
          relationship: {
            director: args[:director],
            executive: args[:executive],
            owner: args[:owner],
            representative: args[:representative],
            percent_ownership: args[:percent_ownership]
          },
        },
      })

      # Ajout de la personne à l'organization avec réutilisation du stripe_token_person
      Stripe::Account.create_person(
        stripe_create_account.id,
        {
          person_token: stripe_token_person,
        }
      )

      bank_account_country = args[:bank_account_country].upcase

      # Création d'un token pour les informations de compte bancaire de l'organization
      stripe_token_bank_account = Stripe::Token.create({
        bank_account: {
          country: bank_account_country,
          currency: args[:bank_account_currency],
          account_holder_name: args[:bank_account_holder_name],
          account_holder_type: 'company',
          account_number: args[:bank_account_number]
        },
      })

      # Création du compte bancaire associer à l'organization créer, et réutilisation du stripe_token_bank_account
      Stripe::Account.create_external_account(
        stripe_create_account.id,
        {
          external_account: stripe_token_bank_account,
        },
      )

      organization = Organization.create!(
        email: args[:email],
        name: args[:name],
        country: args[:country],
        country_code: args[:country_code],
        city: args[:city],
        line1: args[:line1],
        postal_code: args[:postal_code],
        state: args[:state],
        phone: args[:phone],
        tax_id: args[:tax_id],
        vat_id: args[:vat_id],
        recipient: stripe_create_account.id,
        business_name: args[:business_name],
        business_description: args[:business_description],
        organization_url: args[:organization_url],
        fees: 10.0,
        mcc_id: args[:mcc_id],
        currency: args[:bank_account_currency]
      )

      AddRateToOrganizationWorker.perform_async(organization.id)

      member = Member.create!(
        first_name: args[:person_first_name],
        last_name: args[:person_last_name],
        gender: args[:person_gender],
        birthday: "#{args[:person_bd]}/#{args[:person_bm]}/#{args[:person_by]}",
        email: args[:person_email],
        city: args[:person_city],
        line1: args[:person_line1],
        postal_code: args[:person_postal_code],
        state: args[:person_state],
        country: args[:person_country],
        country_code: args[:person_country_code],
        director: args[:director],
        executive: args[:executive],
        owner: args[:owner],
        representative: args[:representative],
        percent_ownership: "#{args[:percent_ownership]}",
        organization_id: organization.id,
        password: args[:password]
      )

      mail = OrganizationMailer.with(organization: organization).welcome
      mail.deliver_now!

      # current_organization needs to be set so authenticationToken can be returned
      context[:current_member] = member

      MutationResult.call(
        obj: { member: member },
        success: member.persisted?,
        errors: member.errors
      )
      rescue ActiveRecord::RecordInvalid => invalid
      GraphQL::ExecutionError.new(
        "Invalid Attributes for #{invalid.record.class.name}: " \
        "#{invalid.record.errors.full_messages.join(', ')}"
      )
    end
  end
end
