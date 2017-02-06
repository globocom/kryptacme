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
curl -v -HContent-type:application/json -X POST -d "{\"name\": \"teste\", \"email\": \"teste@teste.com.br\", \"private_pem\": \""}" http://localhost:3000/projects

GET /projects/[ID]
PUT /projects/[ID]
curl -v -HContent-type:application/json -X PUT -d "{\"name\": \"teste\", \"email\": \"teste@teste.com.br\", \"private_pem\": \"asd\"}" http://localhost:3000/projects

#Certificates
GET /projects/[ID]/certificates
POST /projects/[ID]/certificates
curl -v -HContent-type:application/json -X POST -d "{\"cn\": \"domain\", "project_id": 5}" http://localhost:3000/projects/[ID]/certificates

GET /projects/[ID]/certificates/[ID]
PUT /projects/[ID]/certificates/[ID]
curl -v -HContent-type:application/json -X POST -d "{\"cn\": \"domain\", "project_id": 5}" http://localhost:3000/projects/[ID]/certificates/[ID]

