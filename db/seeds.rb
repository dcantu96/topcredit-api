# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

if Doorkeeper::Application.count.zero?
  Doorkeeper::Application.create(name: "topcredit-app", redirect_uri: "", scopes: "")
end
# To get the client_id and client_secret for the application, run the following commands in the Rails console:
# Doorkeeper::Application.first.secret
# Doorkeeper::Application.first.uid

# generate terms

term_examples = [
  {
    'duration_type': 'two-weeks',
    'duration': 14,
    'name': '14 Quincenas'
  },
  {
    'duration_type': 'months',
    'duration': 30,
    'name': '30 Meses'
  },
  {
    'duration_type': 'years',
    'duration': 4,
    'name': '4 Años'
  },
  {
    'duration_type': 'two-weeks',
    'duration': 7,
    'name': '7 Quincenas'
  },
  {
    'duration_type': 'months',
    'duration': 15,
    'name': '15 Meses'
  }
]

def find_or_initialize_and_update_term(term_params)
  # Find an existing term by duration_type and duration or initialize a new one with the provided duration_type and duration
  term = Term.find_or_initialize_by(duration_type: term_params[:duration_type], duration: term_params[:duration])

  # Assign the rest of the term_params to the term, whether it's a new or found record
  term.assign_attributes(term_params)

  # Validate the term record. This will run the validations in the Term model
  puts term.errors.full_messages if term.invalid?

  # Save the term record to the database. This will perform an INSERT or UPDATE depending on whether the record is new or existing
  if term.new_record? || term.changed?
    puts 'Creating new Term'
    term.save
  end
end

# Create or update the terms
term_examples.each do |term|
  find_or_initialize_and_update_term term
end

# generate companies

company_examples = [
  {
    'name': 'Soriana',
    'domain': 'soriana.com',
    'rate': 0.5,
    'borrowing_capacity': 0.3,
  },
  {
    'name': 'HEB',
    'domain': 'heb.com',
    'rate': 0.40,
    'borrowing_capacity': 0.3,
  },
  {
    'name': 'Staff',
    'domain': 'staff.com',
    'rate': 0.43,
    'borrowing_capacity': 0.25,
  }
]

def find_or_initialize_and_update_company(company_params)
  # Extract the domain from the company params
  domain = company_params.delete(:domain)

  # Find an existing company by domain or initialize a new one with the provided domain
  company = Company.find_or_initialize_by(domain: domain)

  # Assign the rest of the company_params to the company, whether it's a new or found record
  company.assign_attributes(company_params)

  # Assign two random terms to the company
  company.terms = Term.all.sample(2)

  # Validate the company record. This will run the validations in the Company model
  puts company.errors.full_messages if company.invalid?

  # Save the company record to the database. This will perform an INSERT or UPDATE depending on whether the record is new or existing
  if company.new_record? || company.changed?
    puts 'Creating new Company'
    company.save
  end
end

# Create or update the companies
company_examples.each do |company|
  find_or_initialize_and_update_company company
end

# generate staff users

# User with "request" role
user = User.find_or_initialize_by(email: 'requests@staff.com')
user.assign_attributes(
  first_name: 'Request',
  last_name: 'User',
  phone: '1234567890',
  password: '123456',
  status: 'approved',
)
if user.new_record? || user.changed?
  puts 'Creating new Requests Staff'
  user.save
end
# Validate the user record. This will run the validations in the User model
puts user.errors.full_messages if user.invalid?
user.add_role :requests

# User with "admin" role
user = User.find_or_initialize_by(email: 'admin@staff.com')
user.assign_attributes(
  first_name: 'Admin',
  last_name: 'User',
  phone: '1234567890',
  password: '123456',
  status: 'approved',
)
if user.new_record? || user.changed?
  puts 'Creating new Admin'
  user.save
end
# Validate the user record. This will run the validations in the User model
puts user.errors.full_messages if user.invalid?
user.add_role :admin

# User with "pre-authorizations" role
user = User.find_or_initialize_by(email: 'pre-auth@staff.com')
user.assign_attributes(
  first_name: 'Pre-Authorization',
  last_name: 'User',
  phone: '1234567890',
  password: '123456',
  status: 'approved',
)
if user.new_record? || user.changed?
  puts 'Creating new Pre-Authorization Staff'
  user.save
end
# Validate the user record. This will run the validations in the User model
puts user.errors.full_messages if user.invalid?
user.add_role :pre_authorizations

# generate users

user_examples = [
  {
    'email': 'jmercado@soriana.com',
    'first_name': 'Rosalia',
    'last_name': 'Gaytán',
    'phone': '(035)342-5728',
    'employee_number': 'EMP001',
    'bank_account_number': 'BANK001',
    'address_line_one': 'Eje vial República Democrática del Congo 965 798',
    'address_line_two': '362 Interior 174',
    'city': 'Vieja Bolivia',
    'state': 'ZAC',
    'postal_code': '63958-1681',
    'country': 'Mexico',
    'rfc': 'DCUE228616JPD',
    'salary': 57213,
    'salary_frequency': 'M',
    'status': 'pending'
  },
  {
    'email': 'benavidezfidel@heb.com',
    'first_name': 'Enrique',
    'last_name': 'Iglesias',
    'phone': '801-293-8137x119',
    'employee_number': 'EMP002',
    'bank_account_number': 'BANK002',
    'address_line_one': 'Cerrada Serbia 087 Interior 193',
    'address_line_two': '674 045',
    'city': 'San Lilia los bajos',
    'state': 'ROO',
    'postal_code': '57288-6820',
    'country': 'Mexico',
    'rfc': 'NTFV436646PGD',
    'salary': 51750,
    'salary_frequency': 'M',
    'status': 'pending'
  },
  {
    'email': 'benito75@soriana.com',
    'first_name': 'Gerónimo',
    'last_name': 'Villaseñor',
    'phone': '1-095-318-3525',
    'employee_number': 'EMP003',
    'bank_account_number': 'BANK003',
    'address_line_one': 'Prolongación México 072 Edif. 232 , Depto. 457',
    'address_line_two': '578 884',
    'city': 'Nueva Pakistán',
    'state': 'ZAC',
    'postal_code': '22008-6424',
    'country': 'Mexico',
    'rfc': 'YABK231957NPD',
    'salary': 41233,
    'salary_frequency': 'Q',
    'status': 'pending'
  },
  {
    'email': 'irma81@heb.com',
    'first_name': 'Citlali',
    'last_name': 'Gonzales',
    'phone': '+64(9)9990725478',
    'employee_number': 'EMP004',
    'bank_account_number': 'BANK004',
    'address_line_one': 'Avenida Norte Guardado 063 Interior 966',
    'address_line_two': '673 Interior 492',
    'city': 'San Paulina de la Montaña',
    'state': 'MEX',
    'postal_code': '10027-6474',
    'country': 'Mexico',
    'rfc': 'KXEX462458QEX',
    'salary': 55961,
    'salary_frequency': 'M',
    'status': 'pending'
  },
  {
    'email': 'alejandro58@soriana.com',
    'first_name': 'Alejandro',
    'last_name': 'Martinez',
    'phone': '+52(33)8804625190',
    'employee_number': 'EMP008',
    'bank_account_number': 'BANK008',
    'address_line_one': 'Calle de la Reforma 520 Edificio B',
    'address_line_two': 'Apto 302',
    'city': 'Guadalajara del Espíritu Santo',
    'state': 'JAL',
    'postal_code': '44280-8423',
    'country': 'Mexico',
    'rfc': 'MTZA580762HCL',
    'salary': 47500,
    'salary_frequency': 'M',
    'status': 'approved'
  },
  {
    'email': 'luisa.perez@heb.com',
    'first_name': 'Luisa',
    'last_name': 'Perez',
    'phone': '+52(55)765432109',
    'employee_number': 'EMP012',
    'bank_account_number': 'BANK012',
    'address_line_one': 'Privada del Bosque 1987 Residencial Las Flores',
    'address_line_two': 'Casa 45',
    'city': 'Ciudad Juárez',
    'state': 'CHH',
    'postal_code': '32560-4982',
    'country': 'Mexico',
    'rfc': 'PRZL850326MJ2',
    'salary': 62000,
    'salary_frequency': 'M',
    'status': 'approved'
  }
]

def find_or_initialize_and_update_user(user_params)
  # Extract the email from the user params
  email = user_params.delete(:email)

  # Find an existing user by email or initialize a new one with the provided email
  user = User.find_or_initialize_by(email: email)

  # Assign the rest of the user_params to the user, whether it's a new or found record
  user.assign_attributes(user_params)
  user.assign_attributes password: '123456'

  # Validate the user record. This will run the validations in the User model
  puts user.errors.full_messages if user.invalid?

  # Save the user record to the database. This will perform an INSERT or UPDATE depending on whether the record is new or existing
  if user.new_record? || user.changed?
    puts 'Creating new User'
    user.save
  end
end

# Create or update the users
user_examples.each do |user|
  find_or_initialize_and_update_user user
end

