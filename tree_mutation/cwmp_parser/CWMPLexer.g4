lexer grammar CWMPLexer;

// Default "mode": Everything OUTSIDE of a tag
COMMENT : '<!--' .*? '-->';
CDATA   : '<![CDATA[' .*? ']]>';
/** Scarf all DTD stuff, Entity Declarations like <!ENTITY ...>,
 *  and Notation Declarations <!NOTATION ...>
 */
DTD       : '<!' .*? '>' -> skip;
EntityRef : '&' Name ';';
CharRef   : '&#' DIGIT+ ';' | '&#x' HEXDIGIT+ ';';
SEA_WS    : (' ' | '\t' | '\r'? '\n')+;

OPEN         : '<'       -> pushMode(INSIDE);
XMLDeclOpen  : '<?xml'   -> pushMode(INSIDE);
SPECIAL_OPEN : '<?' Name -> more, pushMode(PROC_INSTR);

TEXT: ~[<&]+; // match any 16 bit char other than < and &


// ----------------- Everything INSIDE of a tag ---------------------
mode INSIDE;

// SOAP LAYER
SOAP_ENVELOPE                          : 'soap-env:Envelope';
SOAP_HEADER                            : 'soap-env:Header';
SOAP_BODY                              : 'soap-env:Body';
SOAP_FAULT                             : 'soap-env:Fault';
SOAP_FAULTCODE                         : 'faultcode';
SOAP_FAULTSTRING                       : 'faultstring';
SOAP_FAULT_DETAIL                      : 'detail';
SOAP_ATTRIBUTE_MUSTUNDERSTAND          : S 'soap-env:mustUnderstand="1"';
CWMP_SOAP_HEADER_ELEMENT_ID            : 'cwmp:ID';
CWMP_SOAP_HEADER_ELEMENT_HOLD_REQUESTS : 'cwmp:HoldRequests';

// CWMP RPC tags
CWMP_ADD_OBJECT                  : 'cwmp:AddObject';
CWMP_DELETE_OBJECT               : 'cwmp:DeleteObject';
CWMP_DOWNLOAD                    : 'cwmp:Download';
CWMP_FACTORY_RESET               : 'cwmp:FactoryReset';
CWMP_FAULT                       : 'cwmp:Fault';
CWMP_GET_RPC_METHODS             : 'cwmp:GetRPCMethods';
CWMP_GET_RPC_METHODS_RESPONSE    : 'cwmp:GetRPCMethodsResponse';
CWMP_GET_PARAMETER_ATTRIBUTES    : 'cwmp:GetParameterAttributes';
CWMP_GET_PARAMETER_NAMES         : 'cwmp:GetParameterNames';
CWMP_GET_PARAMETER_VALUES        : 'cwmp:GetParameterValues';
CWMP_RPC_INFORM_RESPONSE         : 'cwmp:InformResponse';
CWMP_REBOOT                      : 'cwmp:Reboot';
CWMP_SCHEDULE_INFORM             : 'cwmp:ScheduleInform';
CWMP_SET_PARAMETER_ATTRIBUTES    : 'cwmp:SetParameterAttributes';
CWMP_SET_PARAMETER_VALUES        : 'cwmp:SetParameterValues';
CWMP_TRANSFER_COMPLETE_RESPONSE  : 'cwmp:TransferCompleteResponse';
CWMP_UPLOAD                      : 'cwmp:Upload';


// CWMP xml tags
CWMP_ACCESS_LIST                     : 'AccessList';
CWMP_ACCESS_LIST_CHANGE              : 'AccessListChange';
CWMP_COMMANDKEY                      : 'CommandKey';
CWMP_DELAY_SECONDS                   : 'DelaySeconds';
CWMP_FAILURE_URL                     : 'FailureURL';
CWMP_FILESIZE                        : 'FileSize';
CWMP_FILETYPE                        : 'FileType';
CWMP_FAULTCODE                       : 'FaultCode';
CWMP_FAULTSTRING                     : 'FaultString';
CWMP_METHODLIST                      : 'MethodList';
CWMP_MAX_ENVELOPES                   : 'MaxEnvelopes';
CWMP_NAME                            : 'Name';
CWMP_NEXT_LEVEL                      : 'NextLevel';
CWMP_NOTIFICATION_CHANGE             : 'NotificationChange';
CWMP_NOTIFICATION                    : 'Notification';
CWMP_OBJECT_NAME                     : 'ObjectName';
CWMP_PARAMETER_KEY                   : 'ParameterKey';
CWMP_PARAMETER_LIST                  : 'ParameterList';
CWMP_PARAMETER_NAMES                 : 'ParameterNames';
CWMP_PARAMETER_PATH                  : 'ParameterPath';
CWMP_PARAMETER_VALUE_STRUCT          : 'ParameterValueStruct';
CWMP_PASSWORD                        : 'Password';
CWMP_SET_PARAMETER_ATTRIBUTES_STRUCT : 'SetParameterAttributesStruct';
CWMP_STRING                          : 'string';
CWMP_SUCCESS_URL                     : 'SuccessURL';
CWMP_TARGET_FILE_NAME                : 'TargetFileName';
CWMP_URL                             : 'URL';
CWMP_USERNAME                        : 'Username';
CWMP_VALUE                           : 'Value';

CLOSE         : '>'  -> popMode;
SPECIAL_CLOSE : '?>' -> popMode; // close <?xml...?>
SLASH_CLOSE   : '/>' -> popMode;
SLASH         : '/';
EQUALS        : '=';
COLON         : ':';
STRING        : '"' ~[<"]* '"' | '\'' ~[<']* '\'';
Name          : S NameStartChar NameChar*;
S             : [ \t\r\n] -> skip;

fragment HEXDIGIT: [a-fA-F0-9];
fragment DIGIT: [0-9];

fragment NameChar:
    NameStartChar
    | '-'
    | '.'
    | DIGIT
    | '\u00B7'
    | '\u0300' ..'\u036F'
    | '\u203F' ..'\u2040'
;

fragment NameStartChar:
    [_:a-zA-Z]
    | '\u2070' ..'\u218F'
    | '\u2C00' ..'\u2FEF'
    | '\u3001' ..'\uD7FF'
    | '\uF900' ..'\uFDCF'
    | '\uFDF0' ..'\uFFFD'
;

// ----------------- Handle <? ... ?> ---------------------
mode PROC_INSTR;

PI     : '?>' -> popMode; // close <?...?>
IGNORE : .    -> more;