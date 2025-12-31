Write-Host "### Atualizando as a secret do database no SecretManager do LocalStack..."

# aws --endpoint http://localhost:4566 --profile $env:PROFILE secretsmanager create-secret --name $env:SECRET --description "Exemplo de Secrets Manager" --secret-string '{\"appname\":\"product\",\"host\":\"jdbc:postgresql://localhost:5432/product\",\"user\":\"admin\",\"pass\":\"passW@rd\",\"dialect\":\"org.hibernate.dialect.PostgreSQLDialect\"}'
aws --endpoint http://localhost:4566 `
--profile "dev" `
secretsmanager update-secret `
--secret-id "product_database_credentials" `
--description "Database credentials for product service" `
--secret-string '{"host":"jdbc:postgresql://localhost:5432/product","user":"admin","pass":"passW@rd","dialect":"org.hibernate.dialect.PostgreSQLDialect"}'

aws --endpoint http://localhost:4566 `
--profile "dev" `
secretsmanager update-secret `
--secret-id "product_database_port" `
--description "Database port connection" `
--secret-string '2524'
