create or replace PACKAGE BODY azure_notification_hubs AS

FUNCTION get_access_token RETURN CLOB IS

BEGIN

    IF gv_token IS NULL OR gv_token_expiration < sysdate THEN

        gv_token := azure_utils.get_sas_access_token ( gc_connection_string );
        gv_token_expiration := sysdate + interval '1' hour;

    END IF;

    return gv_token;

END;

-- read all registrations
-- https://learn.microsoft.com/en-us/rest/api/notificationhubs/read-all-registrations
FUNCTION get_registrations RETURN CLOB IS

    v_token CLOB := get_access_token;
    v_response CLOB;

BEGIN

    azure_utils.set_authorization_header ( v_token );

    v_response := apex_web_service.make_rest_request ( p_url => gc_registrations_url,
                                                        p_http_method => 'GET',
                                                        p_parm_name => apex_string.string_to_table ( 'api-version' ),
                                                        p_parm_value => apex_string.string_to_table ( gc_api_version ));

    return v_response;

END get_registrations;

-- send notification
-- https://learn.microsoft.com/en-us/rest/api/notificationhubs/send-template-notification
PROCEDURE send_notification ( p_payload IN CLOB, p_format IN VARCHAR2, p_tags IN VARCHAR2 DEFAULT NULL) IS

    v_token CLOB := get_access_token;
    v_response CLOB;

BEGIN

    set_authorization_header ( v_token );
    apex_web_service.g_request_headers(2).name := 'Content-Type';
    apex_web_service.g_request_headers(2).value := 'application/json;charset=utf-8';
    apex_web_service.g_request_headers(3).name := 'ServiceBusNotification-Format';
    apex_web_service.g_request_headers(3).value := p_format;

    IF p_tags is not null THEN
        apex_web_service.g_request_headers(4).name := 'ServiceBusNotification-Tags';
        apex_web_service.g_request_headers(4).value := p_tags;
    END IF;

    v_response := apex_web_service.make_rest_request ( p_url => gc_messages_url,
                                                        p_http_method => 'POST',
                                                        p_body => p_payload,
                                                        p_parm_name => apex_string.string_to_table('api-version:test'),
                                                        p_parm_value => apex_string.string_to_table(gc_api_version || ':true'));

END send_notification;

END azure_notification_hubs;