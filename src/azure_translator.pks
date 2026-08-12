create or replace package azure_translator AS

    -- global constants
    gc_subscription_key CONSTANT VARCHAR2(200) := null;
    gc_subscription_region CONSTANT VARCHAR2(20) := null;

    -- endpoint urls
    gc_api_version CONSTANT VARCHAR2(10) := '2026-06-06';
    gc_base_url CONSTANT VARCHAR2(255) := 'https://api.cognitive.microsofttranslator.com';
    gc_translate_url CONSTANT VARCHAR2(255) := gc_base_url || '/translate';

    -- function definitions
    FUNCTION translate ( p_text IN CLOB, p_to_language IN VARCHAR2, p_from_language IN VARCHAR2 DEFAULT NULL ) RETURN CLOB;

END azure_translator;
/
