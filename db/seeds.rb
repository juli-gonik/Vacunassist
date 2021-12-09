# # This file should contain all the record creation needed to seed the database with its default values.
# # The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
# #
# # Examples:
# #
# #   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
# #   Character.create(name: 'Luke', movie: movies.first)



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

100.times do |i|
  email = Faker::Internet.email
  a = UserPatient.create(
    name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    email: email,
    password: email,
    access_key: '1234',
    dni: rand(1_000_000...9_999_999),
    confirmed_at: DateTime.now,
    vacunatorio: Vacunatorio.all.sample,
    birth_date: Faker::Date.between(from: '1920-09-23', to: '2014-09-25'),
    risk_patient: [true, false].sample
  )
  puts "Paciente: #{a.name} #{a.last_name}"
end

puts 'Turnos confirmados'

20.times do |i|
  a = Appointment.new(
    status: :confirmed,
    vaccine: Appointment.vaccines.keys.sample,
    user_patient: UserPatient.where(vacunatorio: Vacunatorio.first).sample,
    tipo: :pedido,
    date: Faker::Date.between(from: Date.today, to: 6.months.from_now)
  )
  a.save
  puts "Vacuna #{i}"
end

20.times do |i|
  a = Appointment.new(
    status: :confirmed,
    vaccine: Appointment.vaccines.keys.sample,
    user_patient: UserPatient.where(vacunatorio: Vacunatorio.second).sample,
    tipo: :pedido,
    date: Faker::Date.between(from: Date.today, to: 6.months.from_now)
  )
  a.save
  puts "Vacuna #{i}"
end

20.times do |i|
  a = Appointment.new(
    status: :confirmed,
    vaccine: Appointment.vaccines.keys.sample,
    user_patient: UserPatient.where(vacunatorio: Vacunatorio.third).sample,
    tipo: :pedido,
    date: Faker::Date.between(from: Date.today, to: 6.months.from_now)
  )
  a.save
  puts "Vacuna #{i}"
end

puts 'Turnos pendientes'

20.times do |i|
  a = Appointment.new(
    status: :pending,
    vaccine: Appointment.vaccines.keys.sample,
    user_patient: UserPatient.where(vacunatorio: Vacunatorio.first).sample,
    tipo: :pedido
  )
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
  a.save
  puts "Vacuna #{i}"
end

puts 'Turnos atendidos'

20.times do |i|
  a = Appointment.new(
    status: :past,
    date: Faker::Date.between(from: 6.months.ago, to: Date.today),
    vaccine: Appointment.vaccines.keys.sample,
    user_patient: UserPatient.where(vacunatorio: Vacunatorio.first).sample,
    tipo: :pedido
  )
  a.save
  puts "Vacuna #{i}"
end

20.times do |i|
  a = Appointment.new(
    status: :past,
    date: Faker::Date.between(from: 6.months.ago, to: Date.today),
    vaccine: Appointment.vaccines.keys.sample,
    user_patient: UserPatient.where(vacunatorio: Vacunatorio.second).sample,
    tipo: :pedido
  )
  a.save
  puts "Vacuna #{i}"
end

20.times do |i|
  a = Appointment.new(
    status: :past,
    date: Faker::Date.between(from: 6.months.ago, to: Date.today),
    vaccine: Appointment.vaccines.keys.sample,
    user_patient: UserPatient.where(vacunatorio: Vacunatorio.third).sample,
    tipo: :pedido
  )
  a.save
  puts "Vacuna #{i}"
end

puts 'Turnos pendientes'

20.times do |i|
  a = Appointment.new(
    status: :pending,
    vaccine: Appointment.vaccines.keys.sample,
    user_patient: UserPatient.where(vacunatorio: Vacunatorio.first).sample,
    tipo: :pedido
  )
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
  a.save
  puts "Vacuna #{i}"
end

puts 'Turnos atendidos'

20.times do |i|
  a = Appointment.new(
    status: :past,
    date: Faker::Date.between(from: 6.months.ago, to: Date.today),
    vaccine: Appointment.vaccines.keys.sample,
    user_patient: UserPatient.where(vacunatorio: Vacunatorio.first).sample,
    tipo: :pedido
  )
  a.save
  puts "Vacuna #{i}"
end

20.times do |i|
  a = Appointment.new(
    status: :past,
    date: Faker::Date.between(from: 6.months.ago, to: Date.today),
    vaccine: Appointment.vaccines.keys.sample,
    user_patient: UserPatient.where(vacunatorio: Vacunatorio.second).sample,
    tipo: :pedido
  )
  a.save
  puts "Vacuna #{i}"
end

20.times do |i|
  a = Appointment.new(
    status: :past,
    date: Faker::Date.between(from: 6.months.ago, to: Date.today),
    vaccine: Appointment.vaccines.keys.sample,
    user_patient: UserPatient.where(vacunatorio: Vacunatorio.third).sample,
    tipo: :pedido
  )
  a.save
  puts "Vacuna #{i}"
end

UserAdmin.create(
  name: 'admin',
  last_name: 'admin',
  email: 'admin@admin.com',
  password: 'admin@admin.com',
  dni: 99_999_999,
  confirmed_at: DateTime.now
)
