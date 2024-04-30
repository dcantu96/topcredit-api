require "open-uri"
require "tempfile"

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

term_examples = [
  { duration_type: "two-weeks", duration: 14, name: "14 Quincenas" },
  { duration_type: "months", duration: 30, name: "30 Meses" },
  { duration_type: "two-weeks", duration: 7, name: "7 Quincenas" },
  { duration_type: "months", duration: 15, name: "15 Meses" },
  { duration_type: "two-weeks", duration: 21, name: "21 Quincenas" },
  { duration_type: "months", duration: 45, name: "45 Meses" },
  { duration_type: "two-weeks", duration: 28, name: "28 Quincenas" },
  { duration_type: "months", duration: 6, name: "6 Meses" },
  { duration_type: "two-weeks", duration: 35, name: "35 Quincenas" }
]

def find_or_initialize_and_update_term(term_params)
  # Find an existing term by duration_type and duration or initialize a new one with the provided duration_type and duration
  term =
    Term.find_or_initialize_by(
      duration_type: term_params[:duration_type],
      duration: term_params[:duration]
    )

  # Assign the rest of the term_params to the term, whether it's a new or found record
  term.assign_attributes(term_params)

  # Save the term record to the database. This will perform an INSERT or UPDATE depending on whether the record is new or existing
  action = term.new_record? ? "Creating" : term.changed? ? "Updating" : nil
  return if action.nil?

  puts "#{action} term #{term.duration} #{term.duration_type}"
  term.save
  puts term.errors.full_messages if term.invalid?
end

# Create or update the terms
term_examples.each { |term| find_or_initialize_and_update_term term }

# generate companies

company_examples = [
  {
    name: "Soriana",
    domain: "soriana.com",
    employee_salary_frequency: "biweekly",
    rate: 0.5,
    borrowing_capacity: 0.3
  },
  {
    name: "HEB",
    domain: "heb.com",
    employee_salary_frequency: "monthly",
    rate: 0.40,
    borrowing_capacity: 0.3
  },
  {
    name: "Walmart",
    domain: "walmart.com",
    employee_salary_frequency: "biweekly",
    rate: 0.45,
    borrowing_capacity: 0.25
  },
  {
    name: "Staff",
    domain: "staff.com",
    employee_salary_frequency: "monthly",
    rate: 0.43,
    borrowing_capacity: 0.25
  }
]

def find_or_initialize_and_update_company(company_params)
  # Extract the domain from the company params

  # Find an existing company by domain or initialize a new one with the provided domain
  company = Company.find_or_initialize_by(domain: company_params[:domain])

  # Assign the rest of the company_params to the company, whether it's a new or found record
  company.assign_attributes(company_params.without(:domain))

  term_duration_type =
    company.employee_salary_frequency == "biweekly" ? "two-weeks" : "months"
  # Assign two random terms to the company
  if company.terms.empty?
    company.terms = Term.where(duration_type: term_duration_type).sample(2)
  end

  # Save the company record to the database. This will perform an INSERT or UPDATE depending on whether the record is new or existing
  action =
    company.new_record? ? "Creating" : company.changed? ? "Updating" : nil
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

users = [
  {
    email: "nuevo@soriana.com",
    first_name: "Rosalia",
    last_name: "Gaytán",
    phone: "(035)342-5728",
    status: "new"
  }
]

staff_users = [
  {
    first_name: "Admin",
    last_name: "User",
    email: "admin@staff.com",
    phone: "1234567890",
    status: "new",
    roles: [:admin]
  },
  {
    first_name: "Request",
    last_name: "User",
    email: "requests@staff.com",
    phone: "1234567890",
    status: "new",
    roles: [:requests]
  },
  {
    first_name: "Pre-Authorization",
    last_name: "User",
    email: "pre-authorizations@staff.com",
    phone: "1234567890",
    status: "new",
    roles: [:pre_authorizations]
  },
  {
    first_name: "Pre-Authorized",
    last_name: "User",
    email: "pre-authorized@staff.com",
    phone: "1234567890",
    status: "new",
    roles: [:pre_authorized]
  },
  {
    first_name: "Auhorization",
    last_name: "User",
    email: "authorizations@staff.com",
    phone: "1234567890",
    status: "new",
    roles: [:authorizations]
  },
  {
    first_name: "Dispersions",
    last_name: "User",
    email: "dispersions@staff.com",
    phone: "1234567890",
    status: "new",
    roles: [:dispersions]
  }
]

first_user_with_documents = {
  email: "jmercado@soriana.com",
  first_name: "Rosalia",
  last_name: "Gaytán",
  phone: "(035)342-5728",
  employee_number: "EMP001",
  bank_account_number: "BANK001",
  address_line_one: "Eje vial República Democrática del Congo 965 798",
  address_line_two: "362 Interior 174",
  city: "Vieja Bolivia",
  state: "ZAC",
  postal_code: "63958",
  country: "Mexico",
  rfc: "DCUE228616JPD",
  salary: 57_213,
  status: "pending",
  identity_document_status: "pending",
  bank_statement_status: "pending",
  payroll_receipt_status: "pending",
  proof_of_address_status: "pending"
}

users_with_documents = [
  {
    email: "benavidezfidel@heb.com",
    first_name: "Enrique",
    last_name: "Iglesias",
    phone: "801-293-8137x119",
    employee_number: "EMP002",
    bank_account_number: "BANK002",
    address_line_one: "Cerrada Serbia 087 Interior 193",
    address_line_two: "674 045",
    city: "San Lilia los bajos",
    state: "ROO",
    postal_code: "57288",
    country: "Mexico",
    rfc: "NTFV436646PGD",
    salary: 51_750,
    status: "pending",
    identity_document_status: "pending",
    bank_statement_status: "pending",
    payroll_receipt_status: "pending",
    proof_of_address_status: "pending"
  },
  {
    email: "benito75@soriana.com",
    first_name: "Gerónimo",
    last_name: "Villaseñor",
    phone: "1-095-318-3525",
    employee_number: "EMP003",
    bank_account_number: "BANK003",
    address_line_one: "Prolongación México 072 Edif. 232 , Depto. 457",
    address_line_two: "578 884",
    city: "Nueva Pakistán",
    state: "ZAC",
    postal_code: "22008",
    country: "Mexico",
    rfc: "YABK231957NPD",
    salary: 41_233,
    status: "pending",
    identity_document_status: "pending",
    bank_statement_status: "pending",
    payroll_receipt_status: "pending",
    proof_of_address_status: "pending"
  },
  {
    email: "irma81@heb.com",
    first_name: "Citlali",
    last_name: "Gonzales",
    phone: "+64(9)9990725478",
    employee_number: "EMP004",
    bank_account_number: "BANK004",
    address_line_one: "Avenida Norte Guardado 063 Interior 966",
    address_line_two: "673 Interior 492",
    city: "San Paulina de la Montaña",
    state: "MEX",
    postal_code: "10027",
    country: "Mexico",
    rfc: "KXEX462458QEX",
    salary: 55_961,
    status: "pending",
    identity_document_status: "pending",
    bank_statement_status: "pending",
    payroll_receipt_status: "pending",
    proof_of_address_status: "pending"
  },
  {
    email: "alejandro58@soriana.com",
    first_name: "Alejandro",
    last_name: "Martinez",
    phone: "+52(33)8804625190",
    employee_number: "EMP008",
    bank_account_number: "BANK008",
    address_line_one: "Calle de la Reforma 520 Edificio B",
    address_line_two: "Apto 302",
    city: "Guadalajara del Espíritu Santo",
    state: "JAL",
    postal_code: "44280",
    country: "Mexico",
    rfc: "MTZA580762HCL",
    salary: 47_500,
    status: "pre-authorization",
    identity_document_status: "approved",
    bank_statement_status: "approved",
    payroll_receipt_status: "approved",
    proof_of_address_status: "approved"
  },
  {
    email: "luisa.perez@heb.com",
    first_name: "Luisa",
    last_name: "Perez",
    phone: "525576543210",
    employee_number: "EMP012",
    bank_account_number: "BANK012",
    address_line_one: "Privada del Bosque 1987 Residencial Las Flores",
    address_line_two: "Casa 45",
    city: "Ciudad Juárez",
    state: "CHH",
    postal_code: "32560",
    country: "Mexico",
    rfc: "PRZL850326MJ2",
    salary: 62_000,
    status: "pre-authorization",
    identity_document_status: "approved",
    bank_statement_status: "approved",
    payroll_receipt_status: "approved",
    proof_of_address_status: "approved"
  }
]

users_with_documents_and_credit = [
  {
    email: "juan.rodriguez@heb.com",
    first_name: "Juan",
    last_name: "Rodriguez",
    phone: "528187654321",
    employee_number: "EMP034",
    bank_account_number: "BANK034",
    address_line_one: "Avenida Revolución 760 Colonia San Pedro",
    address_line_two: "Departamento 502",
    city: "Monterrey",
    state: "NLE",
    postal_code: "64001",
    country: "Mexico",
    rfc: "RDZJ880907HJC",
    salary: 68_000,
    status: "pre-authorized",
    identity_document_status: "approved",
    bank_statement_status: "approved",
    payroll_receipt_status: "approved",
    proof_of_address_status: "approved",
    credit: {
      status: "new",
      loan: 10_000
    }
  }
]

first_user_with_documents_and_credit_docs = {
  email: "maria.lopez@heb.com",
  first_name: "Maria",
  last_name: "Lopez",
  phone: "525598765432",
  employee_number: "EMP056",
  bank_account_number: "BANK056",
  address_line_one: "Calle Olivo 300 Colonia Las Margaritas",
  address_line_two: "Edificio B, Piso 3",
  city: "Guadalajara",
  state: "JAL",
  postal_code: "44100",
  country: "Mexico",
  rfc: "LPEM900415HDF",
  salary: 70_000,
  status: "pre-authorized",
  identity_document_status: "approved",
  bank_statement_status: "approved",
  payroll_receipt_status: "approved",
  proof_of_address_status: "approved",
  credit: {
    status: "pending",
    contract_status: "pending",
    authorization_status: "pending",
    payroll_receipt_status: "pending",
    loan: 25_000
  }
}

users_with_documents_and_credit_and_documents = [
  {
    email: "carlos.gomez@soriana.com",
    first_name: "Carlos",
    last_name: "Gómez",
    phone: "5587654321",
    employee_number: "EMP208",
    bank_account_number: "CUENTA208",
    address_line_one: "Av. Insurgentes Sur 800",
    address_line_two: "Oficina 303, Edificio Boreal",
    city: "Ciudad de México",
    state: "MEX",
    postal_code: "03920",
    country: "México",
    rfc: "GOMC880326HDF",
    salary: 75_000,
    status: "pre-authorized",
    identity_document_status: "approved",
    bank_statement_status: "approved",
    payroll_receipt_status: "approved",
    proof_of_address_status: "approved",
    credit: {
      status: "pending",
      contract_status: "pending",
      authorization_status: "pending",
      payroll_receipt_status: "pending",
      loan: 10_000
    }
  },
  {
    email: "luisa.martinez@soriana.com",
    first_name: "Luisa",
    last_name: "Martínez",
    phone: "5543219876",
    employee_number: "EMP102",
    bank_account_number: "CUENTA102",
    address_line_one: "Paseo de la Reforma 305",
    address_line_two: "Departamento 501, Torre C",
    city: "Ciudad de México",
    state: "MEX",
    postal_code: "06500",
    country: "México",
    rfc: "MRTL850224MJ2",
    salary: 85_000,
    status: "pre-authorized",
    identity_document_status: "approved",
    bank_statement_status: "approved",
    payroll_receipt_status: "approved",
    proof_of_address_status: "approved",
    credit: {
      status: "authorized",
      contract_status: "approved",
      authorization_status: "approved",
      payroll_receipt_status: "approved",
      installation_date: nil,
      installation_status: nil,
      loan: 20_000
    }
  },
  {
    email: "roberto.alvarez@heb.com",
    first_name: "Roberto",
    last_name: "Álvarez",
    phone: "5587654321",
    employee_number: "EMP145",
    bank_account_number: "BANCO145",
    address_line_one: "Boulevard de las Naciones 1489",
    address_line_two: "Condominio Dalia, Casa 8",
    city: "Acapulco",
    state: "GRO",
    postal_code: "39890",
    country: "México",
    rfc: "AERV640918HGR",
    salary: 65_000,
    status: "pre-authorized",
    identity_document_status: "approved",
    bank_statement_status: "approved",
    payroll_receipt_status: "approved",
    proof_of_address_status: "approved",
    credit: {
      status: "authorized",
      contract_status: "approved",
      authorization_status: "approved",
      payroll_receipt_status: "approved",
      installation_date: nil,
      installation_status: nil,
      loan: 20_000
    }
  },
  {
    email: "roberto.lopez@soriana.com",
    first_name: "Roberto",
    last_name: "López",
    phone: "5587654321",
    employee_number: "EMP203",
    bank_account_number: "CUENTA203",
    address_line_one: "Av. Insurgentes Sur 1457",
    address_line_two: "Oficina 303, Edificio Plaza",
    city: "Ciudad de México",
    state: "MEX",
    postal_code: "03920",
    country: "México",
    rfc: "LOPR840516HDFRRL04",
    salary: 8000,
    status: "pre-authorized",
    identity_document_status: "approved",
    bank_statement_status: "approved",
    payroll_receipt_status: "approved",
    proof_of_address_status: "approved",
    credit: {
      contract_status: "approved",
      authorization_status: "approved",
      payroll_receipt_status: "approved",
      loan: 5000,
      status: "dispersed",
      installation_status: "installed",
      dispersed_at: "2024-04-10T10:00:00Z",
      installation_date: "2024-04-15T10:00:00Z"
    }
  },
  {
    email: "jorge.rodriguez@heb.com",
    first_name: "Jorge",
    last_name: "Rodríguez",
    phone: "5587654321",
    employee_number: "EMP145",
    bank_account_number: "BANCO145",
    address_line_one: "Boulevard de las Naciones 1489",
    address_line_two: "Condominio Dalia, Casa 8",
    city: "Acapulco",
    state: "GRO",
    postal_code: "39890",
    country: "México",
    rfc: "AERV640918HGR",
    salary: 65_000,
    status: "pre-authorized",
    identity_document_status: "approved",
    bank_statement_status: "approved",
    payroll_receipt_status: "approved",
    proof_of_address_status: "approved",
    credit: {
      status: "dispersed",
      contract_status: "approved",
      authorization_status: "approved",
      payroll_receipt_status: "approved",
      dispersed_at: "2024-01-19T15:00:00Z",
      installation_date: nil,
      installation_status: nil,
      loan: 20_000
    }
  },
  {
    email: "carlos.torres@heb.com",
    first_name: "Carlos",
    last_name: "Torres",
    phone: "5539876543",
    employee_number: "EMP357",
    bank_account_number: "BANCO357",
    address_line_one: "Calle de la Reforma 505",
    address_line_two: "Torre Platino, Piso 11",
    city: "Acapulco",
    state: "GRO",
    postal_code: "39400",
    country: "México",
    rfc: "TOMC730815HG1",
    salary: 75_000,
    status: "pre-authorized",
    identity_document_status: "approved",
    bank_statement_status: "approved",
    payroll_receipt_status: "approved",
    proof_of_address_status: "approved",
    credit: {
      status: "dispersed",
      contract_status: "approved",
      authorization_status: "approved",
      payroll_receipt_status: "approved",
      dispersed_at: "2024-04-20T15:00:00Z",
      installation_date: nil,
      installation_status: nil,
      loan: 30_000
    }
  },
  {
    email: "laura.jimenez@heb.com",
    first_name: "Laura",
    last_name: "Jimenez",
    phone: "5581234567",
    employee_number: "EMP468",
    bank_account_number: "BANCO468",
    address_line_one: "Paseo de la Vista 777",
    address_line_two: "Conjunto Sol, Apt 504",
    city: "Acapulco",
    state: "GRO",
    postal_code: "39500",
    country: "México",
    rfc: "JIML920305MPL",
    salary: 68_000,
    status: "pre-authorized",
    identity_document_status: "approved",
    bank_statement_status: "approved",
    payroll_receipt_status: "approved",
    proof_of_address_status: "approved",
    credit: {
      status: "dispersed",
      contract_status: "approved",
      authorization_status: "approved",
      payroll_receipt_status: "approved",
      dispersed_at: "2024-02-01T09:30:00Z",
      installation_date: nil,
      installation_status: nil,
      loan: 22_000
    }
  },
  {
    email: "daniel.sanchez@soriana.com",
    first_name: "Daniel",
    last_name: "Sanchez",
    phone: "5546789123",
    employee_number: "EMP579",
    bank_account_number: "BANCO579",
    address_line_one: "Av. Universidad 1234",
    address_line_two: "Villas del Mar, Casa 33",
    city: "Acapulco",
    state: "GRO",
    postal_code: "39600",
    country: "México",
    rfc: "SAND890321HGR",
    salary: 72_000,
    status: "pre-authorized",
    identity_document_status: "approved",
    bank_statement_status: "approved",
    payroll_receipt_status: "approved",
    proof_of_address_status: "approved",
    credit: {
      status: "dispersed",
      contract_status: "approved",
      authorization_status: "approved",
      payroll_receipt_status: "approved",
      dispersed_at: "2022-12-15T14:45:00Z",
      installation_status: "installed",
      installation_date: "2022-12-30T10:00:00Z",
      loan: 28_000
    }
  },
  {
    email: "elena.ramirez@soriana.com",
    first_name: "Elena",
    last_name: "Ramirez",
    phone: "5523344556",
    employee_number: "EMP611",
    bank_account_number: "BANCO611",
    address_line_one: "Calle de la Industria 907",
    address_line_two: "Edificio Luna, Apt 11",
    city: "Acapulco",
    state: "GRO",
    postal_code: "39750",
    country: "México",
    rfc: "RAME760823HDF",
    salary: 76_000,
    status: "pre-authorized",
    identity_document_status: "approved",
    bank_statement_status: "approved",
    payroll_receipt_status: "approved",
    proof_of_address_status: "approved",
    credit: {
      status: "dispersed",
      contract_status: "approved",
      authorization_status: "approved",
      payroll_receipt_status: "approved",
      dispersed_at: "2022-11-10T16:30:00Z",
      installation_status: "installed",
      installation_date: "2022-12-05T09:00:00Z",
      loan: 30_000
    }
  },
  {
    email: "mario.fuentes@soriana.com",
    first_name: "Mario",
    last_name: "Fuentes",
    phone: "5587643210",
    employee_number: "EMP634",
    bank_account_number: "BANCO634",
    address_line_one: "Paseo del Marqués 222",
    address_line_two: "Residencia Coral, Casa 5",
    city: "Acapulco",
    state: "GRO",
    postal_code: "39650",
    country: "México",
    rfc: "FNTM840510HBC",
    salary: 78_000,
    status: "pre-authorized",
    identity_document_status: "approved",
    bank_statement_status: "approved",
    payroll_receipt_status: "approved",
    proof_of_address_status: "approved",
    credit: {
      status: "dispersed",
      contract_status: "approved",
      authorization_status: "approved",
      payroll_receipt_status: "approved",
      dispersed_at: "2022-10-25T13:00:00Z",
      installation_status: "installed",
      installation_date: "2022-11-15T11:00:00Z",
      loan: 32_000
    }
  },
  {
    email: "jimena.hernandez@soriana.com",
    first_name: "Jimena",
    last_name: "Hernandez",
    phone: "5591238765",
    employee_number: "EMP745",
    bank_account_number: "BANCO745",
    address_line_one: "Avenida de los Insurgentes 334",
    address_line_two: "Torre del Parque, Piso 8",
    city: "Acapulco",
    state: "GRO",
    postal_code: "39780",
    country: "México",
    rfc: "HERL881017MPL",
    salary: 74_500,
    status: "pre-authorized",
    identity_document_status: "approved",
    bank_statement_status: "approved",
    payroll_receipt_status: "approved",
    proof_of_address_status: "approved",
    credit: {
      status: "dispersed",
      contract_status: "approved",
      authorization_status: "approved",
      payroll_receipt_status: "approved",
      dispersed_at: "2024-04-21T10:00:00Z",
      installation_status: nil,
      installation_date: nil,
      loan: 27_500
    }
  },
  {
    email: "isabel.martinez@heb.com",
    first_name: "Isabel",
    last_name: "Martinez",
    phone: "5567891234",
    employee_number: "EMP680",
    bank_account_number: "BANCO680",
    address_line_one: "Privada Bosque Real 56",
    address_line_two: "Residencial Azul, Villa 12",
    city: "Acapulco",
    state: "GRO",
    postal_code: "39700",
    country: "México",
    rfc: "MRTI720916HNR",
    salary: 69_000,
    status: "pre-authorized",
    identity_document_status: "approved",
    bank_statement_status: "approved",
    payroll_receipt_status: "approved",
    proof_of_address_status: "approved",
    credit: {
      status: "dispersed",
      contract_status: "approved",
      authorization_status: "approved",
      payroll_receipt_status: "approved",
      dispersed_at: "2023-06-10T16:30:00Z",
      installation_status: "installed",
      installation_date: "2023-06-29T10:00:00Z",
      loan: 24_000
    }
  },
  {
    email: "roberto.flores@heb.com",
    first_name: "Roberto",
    last_name: "Flores",
    phone: "5578912345",
    employee_number: "EMP791",
    bank_account_number: "BANCO791",
    address_line_one: "Calle del Puente 210",
    address_line_two: "Bloque 3, Apartamento 10",
    city: "Acapulco",
    state: "GRO",
    postal_code: "39900",
    country: "México",
    rfc: "FLRR881022HDF",
    salary: 73_000,
    status: "pre-authorized",
    identity_document_status: "approved",
    bank_statement_status: "approved",
    payroll_receipt_status: "approved",
    proof_of_address_status: "approved",
    credit: {
      status: "dispersed",
      contract_status: "approved",
      authorization_status: "approved",
      payroll_receipt_status: "approved",
      dispersed_at: "2024-02-20T10:00:00Z",
      installation_status: "installed",
      installation_date: "2024-03-01T10:00:00Z",
      loan: 27_000
    }
  },
  {
    email: "ana.ramirez@heb.com",
    first_name: "Ana",
    last_name: "Ramirez",
    phone: "5529876543",
    employee_number: "EMP902",
    bank_account_number: "BANCO902",
    address_line_one: "Avenida Revolución 1450",
    address_line_two: "Condominio Esmeralda, Depto 5B",
    city: "Acapulco",
    state: "GRO",
    postal_code: "39950",
    country: "México",
    rfc: "RAMA881205HMN",
    salary: 71_000,
    status: "pre-authorized",
    identity_document_status: "approved",
    bank_statement_status: "approved",
    payroll_receipt_status: "approved",
    proof_of_address_status: "approved",
    credit: {
      status: "dispersed",
      contract_status: "approved",
      authorization_status: "approved",
      payroll_receipt_status: "approved",
      dispersed_at: "2024-04-01T12:00:00Z",
      loan: 26_000,
      installation_status: "installed",
      installation_date: "2024-04-15T15:00:00Z"
    }
  },
  {
    email: "victor.gonzalez@heb.com",
    first_name: "Victor",
    last_name: "Gonzalez",
    phone: "5598765432",
    employee_number: "EMP013",
    bank_account_number: "BANCO013",
    address_line_one: "Blvd de las Palmas 789",
    address_line_two: "Edificio Diamante, Piso 7",
    city: "Acapulco",
    state: "GRO",
    postal_code: "39870",
    country: "México",
    rfc: "GONV920307HPL",
    salary: 74_000,
    status: "pre-authorized",
    identity_document_status: "approved",
    bank_statement_status: "approved",
    payroll_receipt_status: "approved",
    proof_of_address_status: "approved",
    credit: {
      status: "dispersed",
      contract_status: "approved",
      authorization_status: "approved",
      payroll_receipt_status: "approved",
      dispersed_at: "2024-03-20T11:00:00Z",
      loan: 25_000,
      installation_status: "installed",
      installation_date: "2024-03-30T14:30:00Z"
    }
  }
]

def find_or_initialize_and_update_user_credit(user, credit_params)
  if user.credits.empty?
    company = Company.find_by(domain: user.email.split("@").last)
    term_offering = company.term_offerings.sample
    puts "Assigning credit #{user.email} to term offering #{term_offering.term.duration} #{term_offering.term.duration_type} for company #{company.name}"
    credit = Credit.new(user_id: user.id, term_offering_id: term_offering.id)
    credit.assign_attributes(credit_params)
    return credit
  else
    credit = user.credits.first
    credit.assign_attributes(credit_params)

    return credit
  end
end

def attatch_new_files_to_credit(credit, file)
  # Assign documents to the credit
  # leave out "new" and "denied" statuses
  if (
       credit.status == "pending" || credit.status == "invalid-documentation" ||
         credit.status == "authorized" || credit.status == "dispersed"
     )
    if credit.contract.blank?
      file.rewind
      credit.contract.attach(
        io: file,
        filename: "contract.png",
        content_type: "image/png"
      )
      puts "Assigned remote contract doc to credit #{credit.id}"
    end
    if credit.authorization.blank?
      file.rewind
      if credit.authorization.blank?
        credit.authorization.attach(
          io: file,
          filename: "authorization.png",
          content_type: "image/png"
        )
      end
      puts "Assigned remote authorization doc to credit #{credit.id}"
    end
    if credit.payroll_receipt.blank?
      file.rewind
      if credit.payroll_receipt.blank?
        credit.payroll_receipt.attach(
          io: file,
          filename: "payroll_receipt.png",
          content_type: "image/png"
        )
      end
      puts "Assigned remote payroll_receipt doc to credit #{credit.id}"
    end
    if credit.dispersion_receipt.blank?
      file.rewind
      if credit.dispersion_receipt.blank?
        credit.dispersion_receipt.attach(
          io: file,
          filename: "dispersion_receipt.png",
          content_type: "image/png"
        )
      end
      puts "Assigned remote dispersion_receipt doc to credit #{credit.id}"
    end
  end
  credit
end

def attatch_prev_files_to_credit(credit, credit_with_file)
  # Assign documents to the credit
  # leave out "new" and "denied" statuses
  if (
       credit.status == "pending" || credit.status == "invalid-documentation" ||
         credit.status == "authorized" || credit.status == "dispersed"
     )
    if credit.contract.blank?
      credit.contract.attach(credit_with_file.contract.blob)
      puts "Assigned contract documents from blob #{credit_with_file.contract.blob.id}"
    end
    if credit.authorization.blank?
      credit.authorization.attach(credit_with_file.authorization.blob)
      puts "Assigned authorization documents from blob #{credit_with_file.authorization.blob.id}"
    end
    if credit.payroll_receipt.blank?
      credit.payroll_receipt.attach(credit_with_file.payroll_receipt.blob)
      puts "Assigned payroll_receipt documents from blob #{credit_with_file.payroll_receipt.blob.id}"
    end
    if credit.dispersion_receipt.blank?
      credit.dispersion_receipt.attach(credit_with_file.dispersion_receipt.blob)
      puts "Assigned dispersion_receipt documents from blob #{credit_with_file.dispersion_receipt.blob.id}"
    end
  end
  credit
end

def attach_new_files_to_user(user, file)
  # Assign documents to the credit
  # leave out "new" and "denied" statuses
  if (
       user.status == "pending" || user.status == "pre-authorization" ||
         user.status == "pre-authorized" ||
         user.status == "invalid-documentation"
     )
    if user.identity_document.blank?
      file.rewind
      user.identity_document.attach(
        io: file,
        filename: "identity_document.png",
        content_type: "image/png"
      )
      puts "Assigned identity_document remote doc to user #{user.email}"
    end
    if user.bank_statement.blank?
      file.rewind
      user.bank_statement.attach(
        io: file,
        filename: "bank_statement.png",
        content_type: "image/png"
      )
      puts "Assigned bank_statement remote doc to user #{user.email}"
    end

    if user.payroll_receipt.blank?
      file.rewind
      user.payroll_receipt.attach(
        io: file,
        filename: "payroll_receipt.png",
        content_type: "image/png"
      )
      puts "Assigned payroll_receipt remote doc to user #{user.email}"
    end

    if user.proof_of_address.blank?
      file.rewind
      user.proof_of_address.attach(
        io: file,
        filename: "proof_of_address.png",
        content_type: "image/png"
      )
      puts "Assigned proof_of_address remote doc to user #{user.email}"
    end
  end
  user
end

def attach_prev_files_to_user(user, user_with_file)
  # Assign documents to the credit
  # leave out "new" and "denied" statuses
  if (
       user.status == "pending" || user.status == "pre-authorization" ||
         user.status == "pre-authorized" ||
         user.status == "invalid-documentation"
     )
    if user.identity_document.blank?
      user.identity_document.attach(user_with_file.identity_document.blob)
      puts "Assigned identity_document to user #{user.email} from blob #{user_with_file.identity_document.blob.id}"
    end

    if user.bank_statement.blank?
      user.bank_statement.attach(user_with_file.bank_statement.blob)
      puts "Assigned bank_statement to user #{user.email} from blob #{user_with_file.bank_statement.blob.id}"
    end

    if user.payroll_receipt.blank?
      user.payroll_receipt.attach(user_with_file.payroll_receipt.blob)
      puts "Assigned payroll_receipt to user #{user.email} from blob #{user_with_file.payroll_receipt.blob.id}"
    end

    if user.proof_of_address.blank?
      user.proof_of_address.attach(user_with_file.proof_of_address.blob)
      puts "Assigned proof_of_address to user #{user.email} from blob #{user_with_file.proof_of_address.blob.id}"
    end
  end
  user
end

# Create or update the users with basic information like name, email, phone, and status
def find_or_initialize_and_update_user(user_params)
  # Find an existing user by email or initialize a new one with the provided email
  user = User.find_or_initialize_by(email: user_params[:email])

  # Assign the rest of the user_params to the user, whether it's a new or found record
  user.assign_attributes(user_params.without(:email, :roles, :credit))
  user
end

def find_or_initialize_and_update_user_roles(user, user_params)
  roles = user_params[:roles]
  if roles.present?
    roles.each do |role|
      return if user.has_role? role

      puts "- Assigning role #{role}"
      user.add_role role
    end
  end
  user
end

def save_user(user)
  action = user.new_record? ? "Creating" : user.changed? ? "Updating" : nil

  if action.present?
    puts "#{action} user #{user.email}"
    user.assign_attributes password: "123456"
    user.save
  end

  # Validate the user record. This will run the validations in the user model
  if user.invalid?
    puts user.errors.full_messages
    throw :abort
  end
  user
end

def save_credit(credit)
  action = credit.new_record? ? "Creating" : credit.changed? ? "Updating" : nil

  if action.present?
    puts "#{action} credit #{credit.id}"
    credit.save
  end

  # Validate the credit record. This will run the validations in the credit model
  if credit.invalid?
    puts credit.errors.full_messages
    throw :abort
  end
  credit
end

def calculate_total_payments_in_months(duration, duration_type)
  case duration_type
  when "years"
    duration * 12
  when "months"
    duration
  else
    duration / 2
  end
end

def calculate_amortization(loan_amount, total_payments, rate)
  # Calculate the monthly interest rate
  monthly_interest_rate = rate / 12.0

  # Calculate the monthly payment using the formula for amortization
  if monthly_interest_rate == 0
    monthly_payment = loan_amount / total_payments.to_f
  else
    monthly_payment =
      (monthly_interest_rate * loan_amount) /
        (1 - (1 + monthly_interest_rate)**-total_payments)
  end

  # Return the monthly payment rounded to two decimal places
  monthly_payment.round(2)
end

# Create or update the users
users.each do |user_params|
  user = find_or_initialize_and_update_user user_params
  save_user user
end
staff_users.each do |user_params|
  user = find_or_initialize_and_update_user user_params
  find_or_initialize_and_update_user_roles(user, user_params)
  save_user user
end

file_path = Rails.root.join("db", "assets", "150.png")
File.open(file_path, "rb") do |file|
  first_user = find_or_initialize_and_update_user first_user_with_documents
  first_user = attach_new_files_to_user(first_user, file)
  first_user = save_user first_user

  users_with_documents.each do |user_params|
    user = find_or_initialize_and_update_user user_params
    user = attach_prev_files_to_user(user, first_user)
    save_user user
  end

  users_with_documents_and_credit.each do |user_params|
    user = find_or_initialize_and_update_user user_params
    user = attach_prev_files_to_user(user, first_user)
    user = save_user user
    credit =
      find_or_initialize_and_update_user_credit(user, user_params[:credit])
    save_credit credit
  end

  first_user_with_documents_and_credit =
    find_or_initialize_and_update_user first_user_with_documents_and_credit_docs
  first_user_with_documents_and_credit =
    attach_prev_files_to_user(first_user_with_documents_and_credit, first_user)
  first_user_with_documents_and_credit =
    save_user first_user_with_documents_and_credit
  first_credit =
    find_or_initialize_and_update_user_credit(
      first_user_with_documents_and_credit,
      first_user_with_documents_and_credit_docs[:credit]
    )
  first_credit = attatch_new_files_to_credit(first_credit, file)
  first_credit = save_credit first_credit

  users_with_documents_and_credit_and_documents.each do |user_params|
    user = find_or_initialize_and_update_user user_params
    user = attach_prev_files_to_user(user, first_user)
    user = save_user user

    credit =
      find_or_initialize_and_update_user_credit(user, user_params[:credit])
    credit = attatch_prev_files_to_credit(credit, first_credit)
    credit = save_credit credit
    # next: assign "mock" payments depending on the credit term duration and frequency
    if credit.status != "dispersed" || credit.installation_status != "installed"
      next
    end
    next if credit.payments.present?

    installation_date = credit.installation_date
    term_duration = credit.term_offering.term.duration
    term_duration_type = credit.term_offering.term.duration_type
    total_payments =
      calculate_total_payments_in_months(term_duration, term_duration_type)
    amortization_amount =
      calculate_amortization(
        credit.loan,
        total_payments,
        credit.term_offering.company.rate
      )

    payments_to_create =
      Payments.calculate_payments_count(
        installation_date.to_date,
        term_duration_type,
        term_duration
      )
    next if payments_to_create.zero?
    puts "Creating #{payments_to_create} payments for credit #{credit.borrower.email}"
    payments_to_create.times do |i|
      paid_at =
        Payments.get_next_payment_date(
          installation_date.to_date,
          term_duration_type,
          i
        )
      Payment.create(
        credit_id: credit.id,
        amount: amortization_amount,
        paid_at: paid_at.in_time_zone.to_datetime,
        number: i + 1
      )
    end
  end
end

puts "Seeds finished"
