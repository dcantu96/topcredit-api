require 'open-uri'
require 'tempfile'

puts "Seeds started"

if Doorkeeper::Application.count.zero?
  puts "Creating Doorkeeper application: topcredit-app"
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
    'duration_type': 'two-weeks',
    'duration': 7,
    'name': '7 Quincenas'
  },
  {
    'duration_type': 'months',
    'duration': 15,
    'name': '15 Meses'
  },
  {
    'duration_type': 'two-weeks',
    'duration': 21,
    'name': '21 Quincenas'
  },
  {
    'duration_type': 'months',
    'duration': 45,
    'name': '45 Meses'
  },
  {
    'duration_type': 'two-weeks',
    'duration': 28,
    'name': '28 Quincenas'
  },
  {
    'duration_type': 'months',
    'duration': 6,
    'name': '6 Meses'
  },
  {
    'duration_type': 'two-weeks',
    'duration': 35,
    'name': '35 Quincenas'
  }
]

def find_or_initialize_and_update_term(term_params)
  # Find an existing term by duration_type and duration or initialize a new one with the provided duration_type and duration
  term = Term.find_or_initialize_by(duration_type: term_params[:duration_type], duration: term_params[:duration])

  # Assign the rest of the term_params to the term, whether it's a new or found record
  term.assign_attributes(term_params)

  # Save the term record to the database. This will perform an INSERT or UPDATE depending on whether the record is new or existing
  action = term.new_record? ? 'Creating' : term.changed? ? 'Updating' : nil
  return if action.nil?
  
  puts "#{action} term #{term.duration} #{term.duration_type}"
  term.save
  puts term.errors.full_messages if term.invalid?
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
    'employee_salary_frequency': 'biweekly',
    'rate': 0.5,
    'borrowing_capacity': 0.3,
  },
  {
    'name': 'HEB',
    'domain': 'heb.com',
    'employee_salary_frequency': 'monthly',
    'rate': 0.40,
    'borrowing_capacity': 0.3,
  },
  {
    'name': 'Walmart',
    'domain': 'walmart.com',
    'employee_salary_frequency': 'biweekly',
    'rate': 0.45,
    'borrowing_capacity': 0.25,
  },
  {
    'name': 'Staff',
    'domain': 'staff.com',
    'employee_salary_frequency': 'monthly',
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
  
  term_duration_type = company.employee_salary_frequency == "biweekly" ? "two-weeks" : "months"
  # Assign two random terms to the company
  company.terms = Term.where(duration_type: term_duration_type).sample(2)

  # Save the company record to the database. This will perform an INSERT or UPDATE depending on whether the record is new or existing
  action = company.new_record? ? 'Creating' : company.changed? ? 'Updating' : nil
  return if action.nil?
  
  puts "#{action} company #{company.name}"
  company.save
  # Validate the company record. This will run the validations in the Company model
  puts company.errors.full_messages if company.invalid?
end

# Create or update the companies
company_examples.each do |company|
  find_or_initialize_and_update_company company
end

# generate users

user_examples = [
  {
    'first_name': 'Admin',
    'last_name': 'User',
    'email': 'admin@staff.com',
    'phone': '1234567890',
    'status': 'new',
    'roles': [:admin]
  },
  {
    'first_name': 'Request',
    'last_name': 'User',
    'email': 'requests@staff.com',
    'phone': '1234567890',
    'status': 'new',
    'roles': [:requests]
  },
  {
    'first_name': 'Pre-Authorization',
    'last_name': 'User',
    'email': 'pre-authorizations@staff.com',
    'phone': '1234567890',
    'status': 'new',
    'roles': [:pre_authorizations]
  },
  {
    'first_name': 'Pre-Authorized',
    'last_name': 'User',
    'email': 'pre-authorized@staff.com',
    'phone': '1234567890',
    'status': 'new',
    'roles': [:pre_authorized]
  },
  {
    'first_name': 'Auhorization',
    'last_name': 'User',
    'email': 'authorizations@staff.com',
    'phone': '1234567890',
    'status': 'new',
    'roles': [:authorizations]
  },
  {
    'first_name': 'Dispersions',
    'last_name': 'User',
    'email': 'dispersions@staff.com',
    'phone': '1234567890',
    'status': 'new',
    'roles': [:dispersions]
  },
  {
    'email': 'nuevo@soriana.com',
    'first_name': 'Rosalia',
    'last_name': 'Gaytán',
    'phone': '(035)342-5728',
    'status': 'new'
  },
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
    'postal_code': '63958',
    'country': 'Mexico',
    'rfc': 'DCUE228616JPD',
    'salary': 57213,
    'status': 'pending',
    'identity_document_status': 'pending',
    'bank_statement_status': 'pending',
    'payroll_receipt_status': 'pending',
    'proof_of_address_status': 'pending'
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
    'postal_code': '57288',
    'country': 'Mexico',
    'rfc': 'NTFV436646PGD',
    'salary': 51750,
    'status': 'pending',
    'identity_document_status': 'pending',
    'bank_statement_status': 'pending',
    'payroll_receipt_status': 'pending',
    'proof_of_address_status': 'pending'
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
    'postal_code': '22008',
    'country': 'Mexico',
    'rfc': 'YABK231957NPD',
    'salary': 41233,
    'status': 'pending',
    'identity_document_status': 'pending',
    'bank_statement_status': 'pending',
    'payroll_receipt_status': 'pending',
    'proof_of_address_status': 'pending'
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
    'postal_code': '10027',
    'country': 'Mexico',
    'rfc': 'KXEX462458QEX',
    'salary': 55961,
    'status': 'pending',
    'identity_document_status': 'pending',
    'bank_statement_status': 'pending',
    'payroll_receipt_status': 'pending',
    'proof_of_address_status': 'pending'
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
    'postal_code': '44280',
    'country': 'Mexico',
    'rfc': 'MTZA580762HCL',
    'salary': 47500,
    'status': 'pre-authorization',
    'identity_document_status': 'approved',
    'bank_statement_status': 'approved',
    'payroll_receipt_status': 'approved',
    'proof_of_address_status': 'approved'
  },
  {
    'email': 'luisa.perez@heb.com',
    'first_name': 'Luisa',
    'last_name': 'Perez',
    'phone': '525576543210',
    'employee_number': 'EMP012',
    'bank_account_number': 'BANK012',
    'address_line_one': 'Privada del Bosque 1987 Residencial Las Flores',
    'address_line_two': 'Casa 45',
    'city': 'Ciudad Juárez',
    'state': 'CHH',
    'postal_code': '32560',
    'country': 'Mexico',
    'rfc': 'PRZL850326MJ2',
    'salary': 62000,
    'status': 'pre-authorization',
    'identity_document_status': 'approved',
    'bank_statement_status': 'approved',
    'payroll_receipt_status': 'approved',
    'proof_of_address_status': 'approved'
  },
  {
    "email": "juan.rodriguez@heb.com",
    "first_name": "Juan",
    "last_name": "Rodriguez",
    "phone": "528187654321",
    "employee_number": "EMP034",
    "bank_account_number": "BANK034",
    "address_line_one": "Avenida Revolución 760 Colonia San Pedro",
    "address_line_two": "Departamento 502",
    "city": "Monterrey",
    "state": "NLE",
    "postal_code": "64001",
    "country": "Mexico",
    "rfc": "RDZJ880907HJC",
    "salary": 68000,
    "status": "pre-authorized",
    'identity_document_status': 'approved',
    'bank_statement_status': 'approved',
    'payroll_receipt_status': 'approved',
    'proof_of_address_status': 'approved',
    "credit": {
      "status": "new",
      "loan": 10000
    },
  },
  {
    "email": "maria.lopez@heb.com",
    "first_name": "Maria",
    "last_name": "Lopez",
    "phone": "525598765432",
    "employee_number": "EMP056",
    "bank_account_number": "BANK056",
    "address_line_one": "Calle Olivo 300 Colonia Las Margaritas",
    "address_line_two": "Edificio B, Piso 3",
    "city": "Guadalajara",
    "state": "JAL",
    "postal_code": "44100",
    "country": "Mexico",
    "rfc": "LPEM900415HDF",
    "salary": 70000,
    "status": "pre-authorized",
    'identity_document_status': 'approved',
    'bank_statement_status': 'approved',
    'payroll_receipt_status': 'approved',
    'proof_of_address_status': 'approved',
    "credit": {
      "status": "pending",
      "contract_status": "pending",
      "authorization_status": "pending",
      "payroll_receipt_status": "pending",
      "loan": 25000
    },
  },
  {
    "email": "carlos.gomez@soriana.com",
    "first_name": "Carlos",
    "last_name": "Gómez",
    "phone": "5587654321",
    "employee_number": "EMP208",
    "bank_account_number": "CUENTA208",
    "address_line_one": "Av. Insurgentes Sur 800",
    "address_line_two": "Oficina 303, Edificio Boreal",
    "city": "Ciudad de México",
    "state": "MEX",
    "postal_code": "03920",
    "country": "México",
    "rfc": "GOMC880326HDF",
    "salary": 75000,
    "status": "pre-authorized",
    'identity_document_status': 'approved',
    'bank_statement_status': 'approved',
    'payroll_receipt_status': 'approved',
    'proof_of_address_status': 'approved',
    "credit": {
      "status": "pending",
      "contract_status": "pending",
      "authorization_status": "pending",
      "payroll_receipt_status": "pending",
      "loan": 10000
    }
  },
  {
    "email": "luisa.martinez@soriana.com",
    "first_name": "Luisa",
    "last_name": "Martínez",
    "phone": "5543219876",
    "employee_number": "EMP102",
    "bank_account_number": "CUENTA102",
    "address_line_one": "Paseo de la Reforma 305",
    "address_line_two": "Departamento 501, Torre C",
    "city": "Ciudad de México",
    "state": "MEX",
    "postal_code": "06500",
    "country": "México",
    "rfc": "MRTL850224MJ2",
    "salary": 85000,
    "status": "pre-authorized",
    'identity_document_status': 'approved',
    'bank_statement_status': 'approved',
    'payroll_receipt_status': 'approved',
    'proof_of_address_status': 'approved',
    "credit": {
      "status": "authorized",
      "contract_status": "approved",
      "authorization_status": "approved",
      "payroll_receipt_status": "approved",
      "loan": 20000
    }
  },
  {
    "email": "roberto.alvarez@heb.com",
    "first_name": "Roberto",
    "last_name": "Álvarez",
    "phone": "5587654321",
    "employee_number": "EMP145",
    "bank_account_number": "BANCO145",
    "address_line_one": "Boulevard de las Naciones 1489",
    "address_line_two": "Condominio Dalia, Casa 8",
    "city": "Acapulco",
    "state": "GRO",
    "postal_code": "39890",
    "country": "México",
    "rfc": "AERV640918HGR",
    "salary": 65000,
    "status": "pre-authorized",
    'identity_document_status': 'approved',
    'bank_statement_status': 'approved',
    'payroll_receipt_status': 'approved',
    'proof_of_address_status': 'approved',
    "credit": {
      "status": "authorized",
      "contract_status": "approved",
      "authorization_status": "approved",
      "payroll_receipt_status": "approved",
      "loan": 20000
    }
  },
  {
    "email": "jorge.rodriguez@heb.com",
    "first_name": "Jorge",
    "last_name": "Rodríguez",
    "phone": "5587654321",
    "employee_number": "EMP145",
    "bank_account_number": "BANCO145",
    "address_line_one": "Boulevard de las Naciones 1489",
    "address_line_two": "Condominio Dalia, Casa 8",
    "city": "Acapulco",
    "state": "GRO",
    "postal_code": "39890",
    "country": "México",
    "rfc": "AERV640918HGR",
    "salary": 65000,
    "status": "pre-authorized",
    'identity_document_status': 'approved',
    'bank_statement_status': 'approved',
    'payroll_receipt_status': 'approved',
    'proof_of_address_status': 'approved',
    "credit": {
      "status": "dispersed",
      "contract_status": "approved",
      "authorization_status": "approved",
      "payroll_receipt_status": "approved",
      "dispersed_at": Time.now,
      "loan": 20000
    }
  }
]

def find_or_initialize_and_update_user(user_params, file)
  # Extract the email from the user params
  email = user_params.delete(:email)
  roles = user_params.delete(:roles)
  credit_params = user_params.delete(:credit)

  # Find an existing user by email or initialize a new one with the provided email
  user = User.find_or_initialize_by(email: email)

  # Assign the rest of the user_params to the user, whether it's a new or found record
  user.assign_attributes(user_params)

  # Assign documents to the credit
  # leave out "new" and "denied" statuses
  if (user.status == 'pending' || user.status == 'pre-authorization' || user.status == 'pre-authorized' || user.status == 'invalid-documentation')
    file.rewind
    user.identity_document.attach(io: file, filename: 'identity_document.png', content_type: 'image/png') if user.identity_document.blank?
    puts "Assigned identity_document to user #{user.email}"
    file.rewind
    user.bank_statement.attach(io: file, filename: 'bank_statement.png', content_type: 'image/png') if user.bank_statement.blank?
    puts "Assigned bank_statement to user #{user.email}"
    file.rewind
    user.payroll_receipt.attach(io: file, filename: 'payroll_receipt.png', content_type: 'image/png') if user.payroll_receipt.blank?
    puts "Assigned payroll_receipt to user #{user.email}"
    file.rewind
    user.proof_of_address.attach(io: file, filename: 'proof_of_address.png', content_type: 'image/png') if user.proof_of_address.blank?
    puts "Assigned proof_of_address to user #{user.email}"
  end

  action = user.new_record? ? 'Creating' : user.changed? ? 'Updating' : nil

  if action.present?
    puts "#{action} user #{user.email}"
    user.assign_attributes password: '123456'
    user.save
  end

  if roles.present?
    roles.each do |role|
      return if user.has_role? role

      puts "- Assigning role #{role}"
      user.add_role role
    end
  end

  # Validate the user record. This will run the validations in the user model
  puts user.errors.full_messages if user.invalid?

  if credit_params.present?
    credit_term_id = credit_params.delete(:term_id)
    company = Company.find_by(domain: user.email.split('@').last)
    term_offering = company.term_offerings.sample
    puts "Assigning credit #{user.email} to term offering #{term_offering.term.duration} #{term_offering.term.duration_type} for company #{company.name}"
    credit = user.credits.find_or_initialize_by(term_offering_id: term_offering.id)
    credit.assign_attributes(credit_params)

    # Assign documents to the credit
    # leave out "new" and "denied" statuses
    if (credit.status == 'pending' || credit.status == 'invalid-documentation' || credit.status == 'authorized' || credit.status == 'dispersed')
      file.rewind
      credit.contract.attach(io: file, filename: 'contract.png', content_type: 'image/png') if credit.contract.blank?
      file.rewind
      credit.authorization.attach(io: file, filename: 'authorization.png', content_type: 'image/png') if credit.authorization.blank?
      file.rewind
      credit.payroll_receipt.attach(io: file, filename: 'payroll_receipt.png', content_type: 'image/png') if credit.payroll_receipt.blank?
    end

    action = credit.new_record? ? 'Creating' : credit.changed? ? 'Updating' : nil
    return if action.nil?
    puts "- #{action} credit"
    credit.save
    puts credit.errors.full_messages if credit.invalid?
  end
end

# Create or update the users
file_path = Rails.root.join('db', 'assets', '150.png')
File.open(file_path, 'rb') do |file|
  user_examples.each do |user|
    find_or_initialize_and_update_user user, file
  end
end



puts "Seeds finished"

