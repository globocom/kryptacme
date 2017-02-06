# Lets Encrypt as a Service

## Goal

- RESTcentric 
- LE Accounts management
- Promove centralized keys storage
- DNS integration

##Routers available

#Projects
GET /projects
POST /projects
curl -v -HContent-type:application/json -X POST -d "{\"name\": \"tiago-teste\", \"email\": \"tiago-teste@teste.com.br\", \"private_pem\": \"-----BEGIN RSA PRIVATE KEY----- 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 -----END RSA PRIVATE KEY----- \"}" http://tiago.machado:$pass@localhost:3000/projects

GET /projects/[ID]
PUT /projects/[ID]
curl -v -HContent-type:application/json -X PUT -d "{\"name\": \"tiago-teste\", \"email\": \"tiago-teste@teste.com.br\", \"private_pem\": \"asd\"}" http://tiago.machado:$pass@localhost:3000/projects

#Certificates
GET /projects/[ID]/certificates
POST /projects/[ID]/certificates
curl -v -HContent-type:application/json -X POST -d "{\"cn\": \"tiago-teste.globoi.com\", "project_id": 5}" http://tiago.machado:$pass@localhost:3000/projects/[ID]/certificates

GET /projects/[ID]/certificates/[ID]
PUT /projects/[ID]/certificates/[ID]
curl -v -HContent-type:application/json -X POST -d "{\"cn\": \"tiago-teste2.globoi.com\", "project_id": 5}" http://tiago.machado:$pass@localhost:3000/projects/[ID]/certificates/[ID]

