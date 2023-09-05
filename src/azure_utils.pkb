CREATE OR REPLACE PACKAGE BODY azure_utils AS

FUNCTION get_sas_access_token ( p_connection_string IN VARCHAR2 ) RETURN CLOB IS

    v_parts apex_t_varchar2;
    v_endpoint VARCHAR2(255);
    v_shared_key_name VARCHAR2(255);
    v_shared_key_value VARCHAR2(255);

    v_target_uri VARCHAR2(255);
    v_expiry INTEGER;
    v_string_to_sign VARCHAR2(2000);

    v_signature RAW(32);
    v_signature_string VARCHAR2(2000);
    v_token CLOB;

BEGIN

    -- parse connection string
    v_parts := apex_string.split ( p_connection_string, ';' );
    v_endpoint := lower ( 'https' || substr ( v_parts(1), 12 ) );
    v_shared_key_name := substr ( v_parts(2), 21 );
    v_shared_key_value := substr ( v_parts(3), 17 );

    -- create SAS security token
    -- https://learn.microsoft.com/en-us/rest/api/notificationhubs/common-concepts
    v_target_uri := lower ( utl_url.escape ( v_endpoint, true ) );
    v_expiry := ( sysdate - to_date ( '01-JAN-1970 00:00:00', 'DD-MON-YYYY HH24:MI:SS' ) ) * 24 * 60 * 60 + 3600;
    v_string_to_sign := v_target_uri || chr ( 10 ) || to_char ( v_expiry );
    v_signature := dbms_crypto.mac ( utl_raw.cast_to_raw ( v_string_to_sign ), dbms_crypto.hmac_sh256, utl_raw.cast_to_raw ( v_shared_key_value ) );
    v_signature_string := utl_url.escape ( utl_raw.cast_to_varchar2 ( utl_encode.base64_encode ( v_signature ) ), true );
    v_token := 'SharedAccessSignature sr=' || v_target_uri || '&sig=' || v_signature_string || '&se='|| v_expiry || '&skn=' || v_shared_key_value;

    return v_token;

END get_sas_access_token;

PROCEDURE set_authorization_header ( p_token IN VARCHAR2 ) IS

BEGIN

    apex_web_service.g_request_headers.delete();
    apex_web_service.g_request_headers(1).name := 'Authorization';
    apex_web_service.g_request_headers(1).value := p_token;

END set_authorization_header;

PROCEDURE set_content_type_header ( p_content_type IN VARCHAR2 DEFAULT 'application/json' ) IS
BEGIN 

    apex_web_service.g_request_headers(2).name := 'Content-Type';
    apex_web_service.g_request_headers(2).value := p_content_type;

END set_content_type_header;

END azure_utils;
/
