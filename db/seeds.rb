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
    'state': 'Zacatecas',
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
    'state': 'Quintana Roo',
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
    'state': 'Zacatecas',
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
    'state': 'México',
    'postal_code': '10027-6474',
    'country': 'Mexico',
    'rfc': 'KXEX462458QEX',
    'salary': 55961,
    'salary_frequency': 'M',
    'status': 'pending'
  },
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
  user.save if user.new_record? || user.changed?
end

user_examples.each do |user|
  find_or_initialize_and_update_user user
end
