# Lets Encrypt as a Service

## Goal

- RESTcentric 
- LE Accounts management
- Promove centralized keys storage
- DNS integration

##Routers available

```
              Prefix Verb   URI Pattern                            Controller#Action
    new_user_session GET    /users/sign_in(.:format)               devise/sessions#new
        user_session POST   /users/sign_in(.:format)               devise/sessions#create
destroy_user_session DELETE /users/sign_out(.:format)              devise/sessions#destroy
project_certificates GET    /projects/:project_id/certificates     certificates#index
                     POST   /projects/:project_id/certificates     certificates#create
 project_certificate GET    /projects/:project_id/certificates/:id certificates#show
                     PATCH  /projects/:project_id/certificates/:id certificates#update
                     PUT    /projects/:project_id/certificates/:id certificates#update
                     DELETE /projects/:project_id/certificates/:id certificates#destroy
            projects GET    /projects                              projects#index
                     POST   /projects                              projects#create
             project GET    /projects/:id                          projects#show
                     PATCH  /projects/:id                          projects#update
                     PUT    /projects/:id                          projects#update
                     DELETE /projects/:id                          projects#destroy
                root GET    /                                      root#index
```

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
