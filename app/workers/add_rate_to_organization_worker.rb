class AddRateToOrganizationWorker
  include Sidekiq::Worker
  sidekiq_options queue: :default, retry: 1

  def perform(organization_id)
    organization = Organization.find(organization_id)

    rate = Rate.find_by(country: organization.country_code)

    organization.update(
      rate_id: rate.id
    )
  end
end
