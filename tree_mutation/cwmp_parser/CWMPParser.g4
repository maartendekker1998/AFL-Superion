parser grammar CWMPParser;

options {
    tokenVocab = CWMPLexer;
}


// XML DOCUMENT FORMAT
document
    : prolog? misc* soap_envelope misc* EOF
    ;

prolog
    : XMLDeclOpen attribute* SPECIAL_CLOSE
    ;



//
// SOAP LAYER
//

soap_envelope
    : '<' SOAP_ENVELOPE attribute* '>' soap_header soap_body '<' '/' SOAP_ENVELOPE '>'
    ;
    
soap_header
    : '<' SOAP_HEADER attribute* '>' cwmp_soap_header_element* '<' '/' SOAP_HEADER '>'
    | '<' SOAP_HEADER attribute* '/>'
    ;
    
soap_body
    : '<' SOAP_BODY attribute* '>' (soap_fault | cwmp_rpc) '<' '/' SOAP_BODY '>'
    ;

soap_fault
    : '<' SOAP_FAULT '>' soap_faultcode soap_faultstring soap_fault_detail '<' '/' SOAP_FAULT '>'
    ;
    
soap_faultcode
    : '<' SOAP_FAULTCODE '>' content '<' '/' SOAP_FAULTCODE '>'
    ;

soap_faultstring
    : '<' SOAP_FAULTSTRING '>' content '<' '/' SOAP_FAULTSTRING '>'
    ;

soap_fault_detail
    : '<' SOAP_FAULT_DETAIL '>' cwmp_fault '<' '/' SOAP_FAULT_DETAIL '>'
    ;

// if either the 'ID' or 'HoldRequests' SOAP header extentions of CWMP are present
// than the mustUnderstand SOAP attribute must be present
cwmp_soap_header_element
    : '<' CWMP_SOAP_HEADER_ELEMENT_ID SOAP_ATTRIBUTE_MUSTUNDERSTAND '>' content '<' '/' CWMP_SOAP_HEADER_ELEMENT_ID '>'
    | '<' CWMP_SOAP_HEADER_ELEMENT_HOLD_REQUESTS SOAP_ATTRIBUTE_MUSTUNDERSTAND '>' content '<' '/' CWMP_SOAP_HEADER_ELEMENT_HOLD_REQUESTS '>'
    ;



//
// CWMP LAYER
//

cwmp_rpc
    : cwmp_add_object
    | cwmp_delete_object
    | cwmp_download
    | cwmp_factory_reset
    | cwmp_get_rpc_methods
    | cwmp_get_rpc_methods_response
    | cwmp_get_parameter_attributes
    | cwmp_get_parameter_names
    | cwmp_get_parameter_values
    | cwmp_inform_response
    | cwmp_reboot
    | cwmp_schedule_inform
    | cwmp_set_parameter_attributes
    | cwmp_set_parameter_values
    | cwmp_transfer_complete_response
    | cwmp_upload
    ;

//
// ADD OBJECT
//
cwmp_add_object
    : '<' CWMP_ADD_OBJECT '>' object_name parameter_key '<' '/' CWMP_ADD_OBJECT '>' 
    ;

//
// DELETE OBJECT
//
cwmp_delete_object
    : '<' CWMP_DELETE_OBJECT '>' object_name parameter_key '<' '/' CWMP_DELETE_OBJECT '>' 
    ;

//
// DOWNLOAD
//
cwmp_download
    : '<' CWMP_DOWNLOAD '>' commandkey filetype url username password filesize target_file_name delay_seconds success_url failure_url '<' '/' CWMP_DOWNLOAD '>' 
    ;

filesize         : '<' CWMP_FILESIZE '>' content '<' '/' CWMP_FILESIZE '>' ;
target_file_name : '<' CWMP_TARGET_FILE_NAME '>' content '<' '/' CWMP_TARGET_FILE_NAME '>' ;
success_url      : '<' CWMP_SUCCESS_URL '>' content '<' '/' CWMP_SUCCESS_URL '>' ;
failure_url      : '<' CWMP_FAILURE_URL '>' content '<' '/' CWMP_FAILURE_URL '>' ;

//
// FAULT
//

cwmp_fault
    : '<' CWMP_FAULT '>' cwmp_faultcode cwmp_faultstring '<' '/' CWMP_FAULT '>'
    ;

cwmp_faultcode
    : '<' CWMP_FAULTCODE '>' content '<' '/' CWMP_FAULTCODE '>'
    ;

cwmp_faultstring
    : '<' CWMP_FAULTSTRING '>' content '<' '/' CWMP_FAULTSTRING '>'
    ;

//
// FACTORY RESET
//
cwmp_factory_reset
    : '<' CWMP_FACTORY_RESET '/>'
    ;

//
// GET RPC METHODS
//
cwmp_get_rpc_methods
    : '<' CWMP_GET_RPC_METHODS '/>'
    ;

//
// GET RPC METHODS RESPONSE
//
cwmp_get_rpc_methods_response
    : '<' CWMP_GET_RPC_METHODS_RESPONSE '>' methodlist '<' '/' CWMP_GET_RPC_METHODS_RESPONSE '>'
    ;

methodlist
    : '<' CWMP_METHODLIST attribute* '>' string_array '<' '/' CWMP_METHODLIST '>'
    | '<' CWMP_METHODLIST attribute* '/>'
    ;

//
// GET PARAMETER NAMES
//
cwmp_get_parameter_names
    : '<' CWMP_GET_PARAMETER_NAMES '>' parameter_path? next_level '<' '/' CWMP_GET_PARAMETER_NAMES '>'
    ;

parameter_path
    : '<' CWMP_PARAMETER_PATH '>' content '<' '/' CWMP_PARAMETER_PATH '>'
    | '<' CWMP_PARAMETER_PATH '/>'
    ;

next_level
    : '<' CWMP_NEXT_LEVEL '>' content '<' '/' CWMP_NEXT_LEVEL '>'
    ;

//
// GET PARAMETER ATTRIBUTES
//
cwmp_get_parameter_attributes
    : '<' CWMP_GET_PARAMETER_ATTRIBUTES '>' parameter_names '<' '/' CWMP_GET_PARAMETER_ATTRIBUTES '>'
    ;

//
// GET PARAMETER VALUES
//
cwmp_get_parameter_values
    : '<' CWMP_GET_PARAMETER_VALUES '>' parameter_names '<' '/' CWMP_GET_PARAMETER_VALUES '>'
    ;

//
// INFORM RESPONSE
//
cwmp_inform_response
    : '<' CWMP_RPC_INFORM_RESPONSE '>' max_envelopes '<' '/' CWMP_RPC_INFORM_RESPONSE '>'
    ;

max_envelopes
    : '<' CWMP_MAX_ENVELOPES '>' content '<' '/' CWMP_MAX_ENVELOPES '>'
    ;

//
// REBOOT
//
cwmp_reboot
    : '<' CWMP_REBOOT '>' commandkey '<' '/' CWMP_REBOOT '>'
    ;

//
// SCHEDULE INFORM
//
cwmp_schedule_inform
    : '<' CWMP_SCHEDULE_INFORM '>' delay_seconds commandkey '<' '/' CWMP_SCHEDULE_INFORM '>'
    ;

//
// SET PARAMETER VALUES
//
cwmp_set_parameter_values
    : '<' CWMP_SET_PARAMETER_VALUES attribute* '>' '<' CWMP_PARAMETER_LIST attribute* '>' parameter_value_struct* '<' '/' CWMP_PARAMETER_LIST '>' parameter_key? '<' '/' CWMP_SET_PARAMETER_VALUES '>' 
    ;

parameter_value_struct
    : '<' CWMP_PARAMETER_VALUE_STRUCT attribute* '>' struct_name pvs_value '<' '/' CWMP_PARAMETER_VALUE_STRUCT '>'
    ;

pvs_value
    : '<' CWMP_VALUE attribute* '>' content '<' '/' CWMP_VALUE '>'
    ;

//
// SET PARAMETER ATTRIBUTES
//
cwmp_set_parameter_attributes
    : '<' CWMP_SET_PARAMETER_ATTRIBUTES '>' '<' CWMP_PARAMETER_LIST attribute* '>' parameter_attributes_struct* '<' '/' CWMP_PARAMETER_LIST '>' '<' '/' CWMP_SET_PARAMETER_ATTRIBUTES '>' 
    ;

parameter_attributes_struct
    : '<' CWMP_SET_PARAMETER_ATTRIBUTES_STRUCT '>' struct_name? notification_change notification access_list_change access_list '<' '/' CWMP_SET_PARAMETER_ATTRIBUTES_STRUCT '>'
    ;

notification_change
    : '<' CWMP_NOTIFICATION_CHANGE '>' content '<' '/' CWMP_NOTIFICATION_CHANGE '>'
    ;

notification
    : '<' CWMP_NOTIFICATION '>' content '<' '/' CWMP_NOTIFICATION '>'
    ;

access_list_change
    : '<' CWMP_ACCESS_LIST_CHANGE '>' content '<' '/' CWMP_ACCESS_LIST_CHANGE '>'
    ;

access_list
    : '<' CWMP_ACCESS_LIST attribute* '>' string_array '<' '/' CWMP_ACCESS_LIST '>'
    | '<' CWMP_ACCESS_LIST attribute* '/>'
    ;

//
// TRANSFER COMPLETE RESPONSE
//
cwmp_transfer_complete_response
    : '<' CWMP_TRANSFER_COMPLETE_RESPONSE '>' '<' '/' CWMP_TRANSFER_COMPLETE_RESPONSE '>'
    | '<' CWMP_TRANSFER_COMPLETE_RESPONSE '/>'
    ;

//
// UPLOAD
//
cwmp_upload
    : '<' CWMP_UPLOAD '>' commandkey filetype url username password delay_seconds '<' '/' CWMP_UPLOAD '>'
    ;



//
// CWMP REUSABLE
//

commandkey
    : '<' CWMP_COMMANDKEY '>' content '<' '/' CWMP_COMMANDKEY '>'
    ;

delay_seconds 
    : '<' CWMP_DELAY_SECONDS '>' content '<' '/' CWMP_DELAY_SECONDS '>' 
    ;

filetype
    : '<' CWMP_FILETYPE '>' content '<' '/' CWMP_FILETYPE '>' 
    ;

object_name
    : '<' CWMP_OBJECT_NAME '>' content '<' '/' CWMP_OBJECT_NAME '>'
    ;

password
    : '<' CWMP_PASSWORD '>' content '<' '/' CWMP_PASSWORD '>'
    | '<' CWMP_PASSWORD '/>'
    ;

parameter_key
    : '<' CWMP_PARAMETER_KEY attribute* '>' content '<' '/' CWMP_PARAMETER_KEY '>'
    | '<' CWMP_PARAMETER_KEY '/>'
    ;

parameter_names
    : '<' CWMP_PARAMETER_NAMES attribute* '>' string_array '<' '/' CWMP_PARAMETER_NAMES '>'
    | '<' CWMP_PARAMETER_NAMES attribute* '/>'
    ;

string_array
    : ('<' CWMP_STRING '>' content '<' '/' CWMP_STRING '>')*
    ;

struct_name
    : '<' CWMP_NAME attribute* '>' content '<' '/' CWMP_NAME '>'
    ;

url
    : '<' CWMP_URL '>' content '<' '/' CWMP_URL '>' 
    ;

username
    : '<' CWMP_USERNAME '>' content '<' '/' CWMP_USERNAME '>'
    | '<' CWMP_USERNAME '/>'
    ;



// GENERIC XML STUFF

content
    : chardata? ((element | reference | CDATA | PI | COMMENT) chardata?)*
    ;

element
    : '<' Name attribute* '>' content '<' '/' Name '>'
    | '<' Name attribute* '/>'
    ;

reference
    : EntityRef
    | CharRef
    ;

attribute
    : Name '=' STRING
    ; // Our STRING is AttValue in spec

/** ``All text that is not markup constitutes the character data of
 *  the document.''
 */
chardata
    : TEXT
    | SEA_WS
    ;

misc
    : COMMENT
    | PI
    | SEA_WS
    ;