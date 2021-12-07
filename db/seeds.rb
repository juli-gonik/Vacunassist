# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)



puts 'Creando Vacunatorios'
Vacunatorio.create(zone: 0, place: 'Calle 55 1185') unless Vacunatorio.municipalidad.present?
Vacunatorio.create(zone: 1, place: 'Av. 1 599') unless Vacunatorio.terminal.present?
Vacunatorio.create(zone: 2, place: 'C. 71 1562') unless Vacunatorio.cementerio.present?

puts 'Creando Usuario vacunadores'

UserVacunator.create(
  name: 'Vacunador',
  last_name: 'Municipalidad',
  email: 'vacunador1@vacunatorio.com',
  password: 'vacunador1@vacunatorio.com',
  dni: 1_111_111,
  vacunatorio: Vacunatorio.first
)

UserVacunator.create(
  name: 'Vacunador',
  last_name: 'Terminal',
  email: 'vacunador2@vacunatorio.com',
  password: 'vacunador2@vacunatorio.com',
  dni: 2_222_222,
  vacunatorio: Vacunatorio.second
)

UserVacunator.create(
  name: 'Vacunador',
  last_name: 'cementerio',
  email: 'vacunador3@vacunatorio.com',
  password: 'vacunador3@vacunatorio.com',
  dni: 3_333_333,
  vacunatorio: Vacunatorio.third
)

puts 'Vacunadores'

puts '-----Municipalidad------'
puts 'email: vacunador1@vacunatorio.com '
puts 'pass: vacunador1@vacunatorio.com '

puts '-----Terminal------'
puts 'email: vacunador2@vacunatorio.com '
puts 'pass: vacunador2@vacunatorio.com '


puts '-----Cementerio------'
puts 'email: vacunador3@vacunatorio.com '
puts 'pass: vacunador3@vacunatorio.com '

puts 'creando Usuarios pacientes'

20.times do |i|
  UserPatient.create(
    name: "Paciente#{i}",
    last_name: 'Paciente',
    email: "paciente#{i}@paciente.com",
    password: "paciente#{i}@paciente.com",
    access_key: SecureRandom.hex(4),
    dni: rand(1000000...9999999),
    confirmed_at: DateTime.now,
    vacunatorio: Vacunatorio.all.sample,
    birth_date: Date.today,
    risk_patient: [true, false].sample
  )
end

20.times do |i|
  a = Appointment.new(
    status: :confirmed,
    vaccine: Appointment.vaccines.keys.sample,
    user_patient: UserPatient.where(vacunatorio: Vacunatorio.first).sample,
    tipo: :pedido,
    date: Date.today
  )
  puts a.valid?
  puts a.errors&.full_messages
  a.save
  puts "Vacuna #{i}"
end

20.times do |i|
  a = Appointment.new(
    status: :confirmed,
    vaccine: Appointment.vaccines.keys.sample,
    user_patient: UserPatient.where(vacunatorio: Vacunatorio.second).sample,
    tipo: :pedido,
    date: Date.today
  )
  puts a.valid?
  puts a.errors&.full_messages
  a.save
  puts "Vacuna #{i}"
end

20.times do |i|
  a = Appointment.new(
    status: :confirmed,
    vaccine: Appointment.vaccines.keys.sample,
    user_patient: UserPatient.where(vacunatorio: Vacunatorio.third).sample,
    tipo: :pedido,
    date: Date.today
  )
  puts a.valid?
  puts a.errors&.full_messages
  a.save
  puts "Vacuna #{i}"
end

20.times do |i|
  a = Appointment.new(
    status: :pending,
    vaccine: Appointment.vaccines.keys.sample,
    user_patient: UserPatient.where(vacunatorio: Vacunatorio.first).sample,
    tipo: :pedido
  )
  puts a.valid?
  puts a.errors&.full_messages
  a.save
  puts "Vacuna #{i}"
end

20.times do |i|
  a = Appointment.new(
    status: :pending,
    vaccine: Appointment.vaccines.keys.sample,
    user_patient: UserPatient.where(vacunatorio: Vacunatorio.second).sample,
    tipo: :pedido
  )
  puts a.valid?
  puts a.errors&.full_messages
  a.save
  puts "Vacuna #{i}"
end

20.times do |i|
  a = Appointment.new(
    status: :pending,
    vaccine: Appointment.vaccines.keys.sample,
    user_patient: UserPatient.where(vacunatorio: Vacunatorio.third).sample,
    tipo: :pedido
  )
  puts a.valid?
  puts a.errors&.full_messages
  a.save
  puts "Vacuna #{i}"
end
