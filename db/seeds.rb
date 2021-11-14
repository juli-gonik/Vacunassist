# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)



puts 'Creando Vacunatorios'
Vacunatorio.create(zone: 0) unless Vacunatorio.municipalidad.present?
Vacunatorio.create(zone: 1) unless Vacunatorio.terminal.present?
Vacunatorio.create(zone: 2) unless Vacunatorio.cementerio.present?

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
