require "open-uri"
require "tempfile"
include FactoryBot::Syntax::Methods

puts "Seeds started"

# Delete all db if seed is run in production because we cannot run rails db:reset
# if Rails.env.production?
puts "Deleting all data"
Credit.destroy_all
Payment.destroy_all
TermOffering.destroy_all
Term.destroy_all
User.destroy_all
Company.destroy_all
Role.destroy_all
Noticed::Notification.destroy_all
Noticed::Event.destroy_all
puts "Data deleted"
# end

# Create Doorkeeper application if it doesn't exist

if Doorkeeper::Application.count.zero?
  puts "Creating Doorkeeper application: topcredit-app"
  Doorkeeper::Application.create(
    name: "topcredit-app",
    redirect_uri: "",
    scopes: ""
  )
  puts "uid: #{Doorkeeper::Application.first.uid} \nsecret: #{Doorkeeper::Application.first.secret}"
end

create(:user, :admin, email: "admin@staff.com")
create(:user, :authorizations, email: "autorizaciones@staff.com")
create(:user, :dispersions, email: "dispersiones@staff.com")
create(:user, :payments, email: "cobranza@staff.com")
create(:user, :pre_authorizations, email: "pre-autorizaciones@staff.com")
create(:user, :requests, email: "solicitudes@staff.com")

# Create terms.
create_list(:term, 4, :bi_monthly)
create_list(:term, 4, :monthly)

company = create(:company, term_count: 2)
create(:user, :hr, email: "rh@staff.com", hr_company: company)
5.times do
  create(
    :credit,
    :with_documents,
    term_offering: Company.all.sample.term_offerings.sample
  )
end
5.times do
  create(:credit, :authorized, term_offering: company.term_offerings.sample)
end
5.times do
  create(:credit, :hr_approved, term_offering: company.term_offerings.sample)
end
10.times do
  create(:credit, :dispersed, term_offering: company.term_offerings.sample)
end
5.times do
  create(
    :credit,
    :with_missing_payments,
    term_offering: company.term_offerings.sample
  )
end
5.times do
  create(:credit, :defaulted, term_offering: company.term_offerings.sample)
end

company = create(:company, term_count: 2)
5.times do
  create(
    :credit,
    :with_documents,
    term_offering: Company.all.sample.term_offerings.sample
  )
end
5.times do
  create(:credit, :authorized, term_offering: company.term_offerings.sample)
end
5.times do
  create(:credit, :hr_approved, term_offering: company.term_offerings.sample)
end
30.times do
  create(:credit, :dispersed, term_offering: company.term_offerings.sample)
end
3.times do
  create(
    :credit,
    :with_missing_payments,
    term_offering: company.term_offerings.sample
  )
end
3.times do
  create(:credit, :defaulted, term_offering: company.term_offerings.sample)
end

puts "Seeds finished"
