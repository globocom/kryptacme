# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require 'openssl'

o1 = Project.first_or_initialize(name: 'teste1')#Project.create(name: 'teste1', email: 'teste1@example.com', private_pem: OpenSSL::PKey::RSA.new(4096).to_pem)
o2 = Project.create(name: 'teste2', email: 'teste2@example.com', private_pem: OpenSSL::PKey::RSA.new(4096).to_pem)
Project.create(name: 'teste3', email: 'teste3@example.com', private_pem: OpenSSL::PKey::RSA.new(4096).to_pem)
Certificate.create(cn: 'teste1.example.com', project: o1)
Certificate.create(cn: 'teste2.example.com', project: o1)
Certificate.create(cn: 'teste3.example.com', project: o1)
Certificate.create(cn: 'teste4.example.com', project: o2)
