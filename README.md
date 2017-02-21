# Lets Encrypt as a Service

## Goal

- RESTcentric 
- LE Accounts management
- Promove centralized keys storage
- DNS integration

##Routers available

```
              Prefix Verb   URI Pattern                            Controller#Action
        devise_users POST   /users                                 devise/registrations#create
               users GET    /users                                 users#index
                user GET    /users/:id                             users#show
                     PATCH  /users/:id                             users#update
                     PUT    /users/:id                             users#update
                     DELETE /users/:id                             users#destroy
project_certificates GET    /projects/:project_id/certificates     certificates#index
                     POST   /projects/:project_id/certificates     certificates#create
 project_certificate GET    /projects/:project_id/certificates/:id certificates#show
                     PATCH  /projects/:project_id/certificates/:id certificates#update
                     PUT    /projects/:project_id/certificates/:id certificates#update
            projects GET    /projects                              projects#index
                     POST   /projects                              projects#create
             project GET    /projects/:id                          projects#show
                     PATCH  /projects/:id                          projects#update
                     PUT    /projects/:id                          projects#update
                     DELETE /projects/:id                          projects#destroy
        environments GET    /environments                          environments#index
                     POST   /environments                          environments#create
         environment GET    /environments/:id                      environments#show
                     PATCH  /environments/:id                      environments#update
                     PUT    /environments/:id                      environments#update
                     DELETE /environments/:id                      environments#destroy
                root GET    /                                      root#index```

##Examples
###Projects
```
curl -v -HContent-type:application/json -X POST -d "{\"name\": \"teste\", \"email\": \"teste@teste.com.br\", \"private_pem\": \""}" http://localhost:3000/projects
curl -v -HContent-type:application/json -X PUT -d "{\"name\": \"teste\", \"email\": \"teste@teste.com.br\", \"private_pem\": \"asd\"}" http://localhost:3000/projects
```

###Certificates
```
curl -v -HContent-type:application/json -X POST -d "{\"cn\": \"domain\", "project_id": 5}" http://localhost:3000/projects/123/certificates
curl -v -HContent-type:application/json -X POST -d "{\"cn\": \"domain\", "project_id": 5}" http://localhost:3000/projects/123/certificates/456
```
