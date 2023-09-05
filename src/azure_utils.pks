CREATE OR REPLACE PACKAGE azure_utils AS

    -- function definitions
    FUNCTION get_sas_access_token ( p_connection_string IN VARCHAR2 ) RETURN CLOB;
    PROCEDURE set_authorization_header ( p_token IN VARCHAR2 );
    PROCEDURE set_content_type_header ( p_content_type IN VARCHAR2 DEFAULT 'application/json' );

END azure_utils;
/
