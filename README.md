# Lets Encrypt as a Service

## Goal

- RESTcentric
- LE Accounts management
- Promote centralized keys storage
- DNS integration

## Routers available

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
```

## Examples

### Users

```
curl -v -HContent-type:application/json -X POST -d "{\"user\":{\"email\": \"user_example\", \"password\": \"password-example\",\"password_confirmation\": \"password-example\", \"role\":3}}" -u $user:$pass http://localhost:3000/users
```

### Projects

```
curl -v -HContent-type:application/json -X POST -d "{\"name\": \"LocalDomain\", \"email\": \"email@localdomain.com\"}" -u $user:$pass http://localhost:3000/projects
```

### Associate Project User

```
curl -v -HContent-type:application/json -X PUT -d "{\"user\": {\"projects\": [2,5]}}" -u $user:$pass http://@localhost:3000/users/1
```

### Environments

```
curl -v -HContent-type:application/json -X POST -d "{ \"name\":\"env1\", \"destination_crt\": \"/tmp/\"}" -u $user:$pass http://localhost:3000/environments
```

### Certificates

```
curl -v -HContent-type:application/json -X POST -d "{"cn": "localdomain.domain.com", "project_id": 1, "environment_id":"1", "csr": "[CSR]", "key": "[KEY]"}" http://localhost:3000/projects/1/certificates

./doc/create-certs-kryptacme.sh localdomain.domain.com 1 1
```
