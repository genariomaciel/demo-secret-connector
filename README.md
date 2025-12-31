Esta é uma iniciativa promovida pelo canal tech ponto tech.

# **TECH-PONTO-TECH** 

# Demo Secret Connector

Uma aplicação Java que demonstra como integrar o **Secret Connector** para recuperar credenciais e configurações do AWS Secrets Manager usando LocalStack para desenvolvimento local.

## 📋 Descrição

Esta aplicação exemplo mostra como:
- Conectar ao AWS Secrets Manager usando o Secret Connector
- Recuperar segredos armazenados (host, porta, credenciais de banco de dados)
- Usar conversores customizados para transformar segredos em objetos Java
- Executar em ambiente local com Docker e LocalStack

## 🛠️ Pré-requisitos

- **Java**: JDK 11 ou superior
- **Maven**: 3.6+
- **Docker**: Docker Desktop ou Docker Engine
- **Docker Compose**: Para orquestração de containers

## 🐳 Setup do Ambiente com Docker

### 1. Iniciar os Containers

Execute o seguinte comando para criar e iniciar o ambiente:

```bash
docker-compose -f .docker/docker-compose-localstack-secret.yml up -d
```

Este arquivo inicia:
- **LocalStack**: Emula os serviços AWS (Secrets Manager, etc.)
- **Variáveis de Ambiente**: Configuradas automaticamente

### 2. Criar os Segredos no LocalStack

Execute os scripts PowerShell para criar os segredos:

```powershell
# Windows
.\.docker\create-secret.ps1

# Ou atualizar segredos existentes
.\.docker\update-secret.ps1
```

Estes scripts criam segredos como:
- `product/database/host`
- `product/database/port`
- `product/database/credentials`

### 3. Verificar os Containers

```bash
docker-compose -f .docker/docker-compose-localstack-secret.yml ps
```

## 🔨 Compilação e Execução

### Compilar o Projeto

```bash
mvn clean compile
```

### Executar a Aplicação

```bash
mvn exec:java -Dexec.mainClass="com.tecpontotec.demo.Application"
```

Ou compile um JAR:

```bash
mvn clean package
java -jar target/demo-secret-connector-1.0.jar
```

## 📦 Estrutura do Projeto

```
src/
├── main/
│   └── java/com/tecpontotec/demo/
│       ├── Application.java          # Classe principal
│       └── models/
│           └── DatabaseCredentials.java
└── test/
    └── java/com/tecpontotec/demo/
```

## 🔐 Classe Application

### Funcionamento

A classe `Application` é responsável por:

#### 1. **Configuração da Conexão com LocalStack**

```java
String region = "us-east-1";
String accessKey = "local-stack-id";
String secretKey = "local-stack-secret";
String endpoint = "http://localhost:4566";
```

Define as credenciais e endpoint do LocalStack (não usar em produção).

#### 2. **Inicialização do Secret Connector**

```java
SecretManagerConnector<String> connector = 
    new SecretManagerConnector(
        Application.createForLocalStack(region, endpoint, accessKey, secretKey)
    );
```

Cria uma instância do conector que gerencia a comunicação com Secrets Manager.

#### 3. **Recuperação de Segredos**

```java
// Recuperar string simples
connector.get("product/database/host", String.class);

// Recuperar tipo primitivo convertido
connector.get("product/database/port", Integer.class);

// Recuperar objeto complexo usando conversor
connector.get("product/database/credentials", 
    SecretConverters.asObject(DatabaseCredentials.class));
```

O conector suporta:
- **Tipos simples**: String, Integer, Double, etc.
- **Objetos complexos**: Converte JSON automaticamente

#### 4. **Limpeza de Recursos**

```java
connector.close();
```

Fecha a conexão com Secrets Manager.

### Método Helper: createForLocalStack

```java
private static SecretsManagerClient createForLocalStack(
    String region, String endpoint, String accessKey, String secretKey) {
    return SecretsManagerClient.builder()
        .region(Region.of(region))
        .endpointOverride(URI.create(endpoint))
        .credentialsProvider(
            StaticCredentialsProvider.create(
                AwsBasicCredentials.create(accessKey, secretKey)
            )
        )
        .build();
}
```

Cria um cliente AWS SDK v2 configurado para:
- Usar LocalStack como endpoint
- Autenticar com credenciais locais
- Conectar à região especificada

## 📝 Logging

A aplicação usa **SLF4J** com Logger registrado:

```java
private static final Logger logger = LoggerFactory.getLogger(Application.class);

logger.info("Host database connection: {}", 
    connector.get("product/database/host", String.class));
```

Verifique os logs em `volume/logs/` após execução.

## 🔌 Dependências Principais

- **AWS SDK v2**: Para integração com AWS Secrets Manager
- **Secret Connector**: Biblioteca customizada para simplificar acesso a segredos
- **SLF4J**: Para logging
- **Maven**: Build e gerenciamento de dependências

Veja `pom.xml` para todas as dependências.

## 🧪 Parando o Ambiente

```bash
docker-compose -f .docker/docker-compose-localstack-secret.yml down
```

Para remover volumes:

```bash
docker-compose -f .docker/docker-compose-localstack-secret.yml down -v
```

## 🚀 Próximos Passos

1. Customizar os segredos em `create-secret.ps1`
2. Estender `DatabaseCredentials` com novos campos
3. Implementar testes automatizados
4. Integrar com sua aplicação principal

## 📚 Referências

- [AWS Secrets Manager Documentation](https://docs.aws.amazon.com/secretsmanager/)
- [LocalStack Documentation](https://docs.localstack.cloud/)
- [AWS SDK for Java v2](https://github.com/aws/aws-sdk-java-v2)
- [Secret Connector Repository](https://github.com/genariomaciel/secret-connector)

## 📄 Licença

Verifique o arquivo `LICENSE` no repositório.
