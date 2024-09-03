require "sendgrid-ruby"
include SendGrid

class SendgridMailer < Devise::Mailer
  include Devise::Controllers::UrlHelpers
  include DeviseInvitable::Mailer

  def invitation_instructions(record, token, opts = {})
    sg_mail = SendGrid::Mail.new # Explicitly use the SendGrid Mail class
    sg_mail.from = SendGrid::Email.new(email: "soporte@topcredit.mx") # Your email

    personalization = SendGrid::Personalization.new
    personalization.add_to(SendGrid::Email.new(email: record.email)) # Recipient's email
    base_url =
      (
        if Rails.env.production?
          "https://topcredit.mx/generate-password?"
        else
          "http://localhost:3000/generate-password?"
        end
      )
    base_url += "invitation_token=#{token}"
    base_url += "&invitation_url=#{invitation_url(record)}" # Generate invitation URL
    personalization.add_dynamic_template_data(
      {
        "userName" => record.first_name,
        "role" => record.all_roles.first,
        "invitationUrl" => base_url # Generate invitation URL
      }
    )
    sg_mail.add_personalization(personalization)
    sg_mail.template_id = "d-e50091865b804d43ab03cf75d30882aa"

    sg = SendGrid::API.new(api_key: ENV["SENDGRID_API_KEY"])

    begin
      response = sg.client.mail._("send").post(request_body: sg_mail.to_json)
      # Log or handle the response as needed
      puts response.status_code
      puts response.body
      puts response.headers
    rescue Exception => e
      puts e.message
    end
  end

  def confirmation_instructions(record, token, opts = {})
    sg_mail = SendGrid::Mail.new # Explicitly use the SendGrid Mail class
    sg_mail.from = SendGrid::Email.new(email: "soporte@topcredit.mx") # Your email

    personalization = SendGrid::Personalization.new
    personalization.add_to(SendGrid::Email.new(email: record.email)) # Recipient's email
    personalization.add_dynamic_template_data(
      {
        "userName" => record.first_name,
        "confirmationUrl" => user_confirmation_url(confirmation_token: token) # Generate confirmation URL
      }
    )
    sg_mail.add_personalization(personalization)
    sg_mail.template_id = "d-38f4b9f5f6bb474488f01fceb87a25cc"

    sg = SendGrid::API.new(api_key: ENV["SENDGRID_API_KEY"])
    begin
      response = sg.client.mail._("send").post(request_body: sg_mail.to_json)
      # Log or handle the response as needed
      puts response.status_code
      puts response.body
      puts response.headers
    rescue Exception => e
      puts e.message
    end
  end
end
