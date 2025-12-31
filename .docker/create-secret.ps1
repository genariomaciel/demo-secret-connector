Write-Host "### Criando Queue(Standard) a secret do database no SecretManager do LocalStack..."

aws --endpoint http://localhost:4566 `
--profile "dev" `
secretsmanager delete-secret `
--secret-id "product/database/credentials" `
--force-delete-without-recovery

aws --endpoint http://localhost:4566 `
--profile "dev" `
secretsmanager delete-secret `
--secret-id "product/database/host" `
--force-delete-without-recovery

aws --endpoint http://localhost:4566 `
--profile "dev" `
secretsmanager delete-secret `
--secret-id "product/database/port" `
--force-delete-without-recovery

aws --endpoint http://localhost:4566 `
--profile "dev" `
secretsmanager create-secret `
--name "product/database/credentials" `
--description "Database credentials for product service" `
--secret-string '{\"host\":\"jdbc:postgresql://localhost:5432/product\",\"user\":\"admin\",\"pass\":\"passW@rd\",\"dialect\":\"org.hibernate.dialect.PostgreSQLDialect\"}'

aws --endpoint http://localhost:4566 `
--profile "dev" `
secretsmanager create-secret `
--name "product/database/host" `
--description "Database host connection" `
--secret-string 'http://localhost'

aws --endpoint http://localhost:4566 `
--profile "dev" `
secretsmanager create-secret `
--name "product/database/port" `
--description "Database port connection" `
--secret-string '2524'


