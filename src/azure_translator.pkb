CREATE OR REPLACE PACKAGE BODY azure_translator AS

FUNCTION translate (
    p_text          IN CLOB,
    p_to_language   IN VARCHAR2,
    p_from_language IN VARCHAR2 DEFAULT NULL
) RETURN CLOB IS

    v_payload  CLOB;
    v_response CLOB;

BEGIN

    apex_json.initialize_clob_output;
    BEGIN
    apex_json.open_object;
    apex_json.open_array ( 'inputs' );
    apex_json.open_object;
    apex_json.write ( 'text', p_text );
    apex_json.write ( 'language', p_from_language );

    apex_json.open_array ( 'targets' );
    apex_json.open_object;
    apex_json.write ( 'language', p_to_language );
    apex_json.close_object;
    apex_json.close_array;
    apex_json.close_object;
    apex_json.close_array;
    apex_json.close_object;

    v_payload := apex_json.get_clob_output;

    apex_web_service.g_request_headers.delete;
    apex_web_service.g_request_headers(1).name := 'Content-Type';
    apex_web_service.g_request_headers(1).value := 'application/json';
    apex_web_service.g_request_headers(2).name := 'Ocp-Apim-Subscription-Key';
    apex_web_service.g_request_headers(2).value := gc_subscription_key;
    apex_web_service.g_request_headers(3).name := 'Ocp-Apim-Subscription-Region';
    apex_web_service.g_request_headers(3).value := gc_subscription_region;

    v_response := apex_web_service.make_rest_request (
        p_url         => gc_translate_url || '?api-version=' || gc_api_version,
        p_http_method => 'POST',
        p_body        => v_payload
    );

    apex_json.free_output;
    EXCEPTION
        WHEN OTHERS THEN
            apex_json.free_output;
            RAISE;
    END;

    RETURN v_response;

END translate;

END azure_translator;
/
