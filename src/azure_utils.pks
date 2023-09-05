CREATE OR REPLACE PACKAGE azure_utils AS

    -- function definitions
    FUNCTION get_sas_access_token ( p_connection_string IN VARCHAR2 ) RETURN CLOB;
    PROCEDURE set_authorization_header ( p_token IN VARCHAR2 );

END azure_utils;
/
