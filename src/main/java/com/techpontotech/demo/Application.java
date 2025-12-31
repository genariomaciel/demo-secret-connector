package com.techpontotech.demo;

import java.net.URI;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.techpontotech.demo.models.DatabaseCredentials;
import com.techpontotech.secretconnector.SecretManagerConnector;
import com.techpontotech.secretconnector.converter.impl.SecretConverters;

import software.amazon.awssdk.auth.credentials.AwsBasicCredentials;
import software.amazon.awssdk.auth.credentials.StaticCredentialsProvider;
import software.amazon.awssdk.services.secretsmanager.SecretsManagerClient;
import software.amazon.awssdk.regions.Region;
/**
 * Hello world!
 *
 */
public class Application {

    private static final Logger logger = LoggerFactory.getLogger(Application.class);
    
    public static void main(String[] args) throws Exception {
        
        String region = "us-east-1";
        String accessKey = "local-stack-id";
        String secretKey = "local-stack-secret";
        String endpoint = "http://localhost:4566";

        @SuppressWarnings({ "rawtypes", "unchecked" })
        SecretManagerConnector<String> connector = new SecretManagerConnector(Application.createForLocalStack(region, endpoint, accessKey, secretKey));

        logger.info("Host database connection: {}", connector.get("product/database/host", String.class));
        logger.info("Port database connection: {}", connector.get("product/database/port", Integer.class));
        logger.info("Database Credentials: {}", connector.get("product/database/credentials", SecretConverters.asObject(DatabaseCredentials.class)));

        connector.close();

    }

    private static SecretsManagerClient createForLocalStack(String region, String endpoint, String accessKey, String secretKey) {
        return SecretsManagerClient.builder()
        .region(Region.of(region))
        .endpointOverride(URI.create(endpoint)) 
        .credentialsProvider(StaticCredentialsProvider.create(AwsBasicCredentials.create(accessKey, secretKey)))
        .build();
    }
}
