require "open-uri"
require "tempfile"
include FactoryBot::Syntax::Methods

puts "Seeds started"

if Doorkeeper::Application.count.zero?
  puts "Creating Doorkeeper application: topcredit-app"
  Doorkeeper::Application.create(
    name: "topcredit-app",
    redirect_uri: "",
    scopes: ""
  )
end

# To get the client_id and client_secret for the application, run the following commands in the Rails console:
# Doorkeeper::Application.first.uid
# Doorkeeper::Application.first.secret

create(:user, :admin, email: "admin@staff.com")

# Create terms.
create_list(:term, 4, :biweekly)
create_list(:term, 4, :monthly)

# Create users.
company = create(:company, term_count: 2)
10.times do
  create(
    :credit,
    :with_documents,
    :dispersed,
    :installed,
    term_offering: company.term_offerings.sample
  )
end
company = create(:company, term_count: 3)
20.times do
  create(
    :credit,
    :with_documents,
    :dispersed,
    :installed,
    term_offering: company.term_offerings.sample
  )
end
company = create(:company, term_count: 3)
100.times do
  create(
    :credit,
    :with_documents,
    :dispersed,
    :installed,
    term_offering: company.term_offerings.sample
  )
end
company = create(:company, term_count: 3)
400.times do
  create(
    :credit,
    :with_documents,
    :dispersed,
    :installed,
    term_offering: company.term_offerings.sample
  )
end

puts "Seeds finished"
