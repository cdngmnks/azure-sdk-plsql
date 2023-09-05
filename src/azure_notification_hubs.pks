create or replace PACKAGE azure_notification_hubs AS

    -- global constants
    gc_connection_string CONSTANT VARCHAR2(200) := null;
    gc_notification_hub_name CONSTANT VARCHAR2(20) := null;
    gc_notification_hub_namespace CONSTANT VARCHAR2(20) := null;

    -- endpoint urls
    gc_api_version CONSTANT VARCHAR2(7) := '2015-01';
    gc_base_url CONSTANT VARCHAR2(255) := 'https://' || gc_notification_hub_namespace || '.servicebus.windows.net/' || gc_notification_hub_name;
    gc_registrations_url CONSTANT VARCHAR2(255) := gc_base_url || '/registrations/';
    gc_messages_url CONSTANT VARCHAR2(255) := gc_base_url || '/messages/';

    -- global variables
    gv_endpoint VARCHAR2(200);
    gv_shared_key_name VARCHAR2(200);
    gv_shared_key_value VARCHAR2(200);
    gv_sas_token CLOB;
    gv_sas_token_expiration DATE;

    -- function definitions
    FUNCTION get_registrations RETURN CLOB;
    PROCEDURE send_notification ( p_payload IN CLOB, p_format IN VARCHAR2, p_tags IN VARCHAR2 DEFAULT NULL);

END azure_notification_hubs;