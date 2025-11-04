targetScope = 'resourceGroup'

@minLength(1)
@maxLength(64)
@description('Name of the environment that can be used as part of naming resource convention')
param environmentName string

@minLength(1)
@description('Primary location for all resources')
param location string

// Generate a unique token for resource names
var resourceToken = uniqueString(subscription().id, resourceGroup().id, location, environmentName)

// Resource name prefixes  
var appServicePlanName = 'azasp${resourceToken}'
var appServiceName = 'azapp${resourceToken}'
var staticWebAppName = 'azswa${resourceToken}'

// App Service Plan - Free tier
resource appServicePlan 'Microsoft.Web/serverfarms@2023-12-01' = {
  name: appServicePlanName
  location: location
  sku: {
    name: 'F1'
    tier: 'Free'
  }
  properties: {
    reserved: true // Linux
  }
}

// App Service for Backend
resource appService 'Microsoft.Web/sites@2023-12-01' = {
  name: appServiceName
  location: location
  tags: {
    'azd-service-name': 'backend'
  }
  properties: {
    serverFarmId: appServicePlan.id
    siteConfig: {
      linuxFxVersion: 'JAVA|17-java17'
      cors: {
        allowedOrigins: ['*']
        supportCredentials: false
      }
      appSettings: [
        {
          name: 'DATABASE_URL'
          value: ''  // Will be set via environment variables
        }
        {
          name: 'JWT_SECRET'
          value: 'pickme-jwt-secret-key-2024'  
        }
        {
          name: 'SPRING_PROFILES_ACTIVE'
          value: 'prod'
        }
      ]
    }
  }
}

// Static Web App for Frontend
resource staticWebApp 'Microsoft.Web/staticSites@2023-12-01' = {
  name: staticWebAppName
  location: location
  tags: {
    'azd-service-name': 'frontend'
  }
  sku: {
    name: 'Free'
    tier: 'Free'
  }
  properties: {
    buildProperties: {
      skipGithubActionWorkflowGeneration: true
    }
  }
}

// Outputs
output RESOURCE_GROUP_ID string = resourceGroup().id
output BACKEND_URI string = 'https://${appService.properties.defaultHostName}'
output FRONTEND_URI string = 'https://${staticWebApp.properties.defaultHostname}'