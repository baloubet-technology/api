class OrganizationMailer < ApplicationMailer
  def welcome
    @organization = params[:organization]

    mail(
      to: @organization.email,
      subject: "Confirmation d'inscription!"
    )
  end
end
