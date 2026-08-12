# azure-sdk-plsql
Microsoft Azure SDK for PL/SQL

# Package Structure
Package | Description 
------- | ---- 
azure_config | Global constants, environment settings
azure_utils | shared functionality, token handling
azure_notification_hubs | implementing [Azure Notification Hubs](https://learn.microsoft.com/en-us/rest/api/notificationhubs/use-notification-hubs-rest-interface)
azure_translator | implementing [Azure Translator](https://learn.microsoft.com/en-us/azure/ai-services/translator/text-translation/2026-06-06/rest-api-guide)

# Coverage
The following areas and functionalities are covered by the SDK.

Area | Functionality | Action | Endpoint
---- | ------------- | ------ | --------
Notification Hubs | get registrations | GET | /registrations
Notification Hubs | send notification | POST | /messages
Azure Translator | translase | POST | /translate
