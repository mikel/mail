%%{
# RFC 5322 Section 3.6 Field Definitions
# https://tools.ietf.org/html/rfc5322#section-3.6
#
# RFC 6854 Update to Internet Message Format to Allow Group Syntax in the "From:" and "Sender:" Header Fields
# https://tools.ietf.org/html/rfc6854
machine rfc5322_fields;
alphtype int;

include rfc5234_abnf_core_rules "rfc5234_abnf_core_rules.rl";

# 3.2. Lexical Tokens
include rfc5322_lexical_tokens "rfc5322_lexical_tokens.rl";

# 3.3. Date and Time Specification
include rfc5322_date_time "rfc5322_date_time.rl";

# 3.4. Address Specification
include rfc5322_address "rfc5322_address.rl";


# 3.6. Field Definitions

# 3.6.1. The Origination Date Field
# https://tools.ietf.org/html/rfc5322#section-3.6.1
orig_date = "Date:" date_time CRLF;

# 4.5.1. Obsolete Origination Date Field
# https://tools.ietf.org/html/rfc5322#section-4.5.1
obs_orig_date = "Date" WSP* ":" date_time CRLF;

# 3.6.2. Originator Fields
# https://tools.ietf.org/html/rfc5322#section-3.6.2
from_field = "From:" mailbox_list CRLF;
sender = "Sender:" mailbox CRLF;
reply_to = "Reply-To:" address_list CRLF;

# 4.5.2. Obsolete Originator Fields
# https://tools.ietf.org/html/rfc5322#section-4.5.2
obs_from = "From" WSP* ":" mailbox_list CRLF;
obs_sender = "Sender" WSP* ":" mailbox CRLF;
obs_reply_to = "Reply-To" WSP* ":" address_list CRLF;

# 3.6.3. Destination Address Fields
# https://tools.ietf.org/html/rfc5322#section-3.6.3
to_field = "To:" address_list CRLF;
cc = "Cc:" address_list CRLF;
bcc = "Bcc:" (address_list | CFWS) CRLF;

# 4.5.3. Obsolete Destination Address Fields
# https://tools.ietf.org/html/rfc5322#section-4.5.3
obs_to  = "To" WSP* ":" address_list CRLF;
obs_cc  = "Cc" WSP* ":" address_list CRLF;
obs_bcc = "Bcc" WSP* ":" (address_list | ((CFWS? ",")* CFWS?)) CRLF;

# 3.6.4. Identification Fields
obs_id_left = local_part;
id_left = dot_atom_text | obs_id_left;
# id_right modifications to support multiple '@' in msg_id.
msg_id_atext = ALPHA | DIGIT | "!" | "#" | "$" | "%" | "&" | "'" | "*" |
               "+" | "-" | "/" | "=" | "?" | "^" | "_" | "`" | "{" | "|" |
               "}" | "~" | "@";
msg_id_dot_atom_text = (msg_id_atext+ "."?)+;
obs_id_right = domain;
no_fold_literal = "[" dtext* "]";
id_right = msg_id_dot_atom_text | no_fold_literal | obs_id_right;
msg_id = (CFWS)?
         (("<" id_left "@" id_right ">") >msg_id_s %msg_id_e)
         (CFWS)?;
message_ids = msg_id (CFWS? msg_id)*;

message_id = "Message-ID:" msg_id CRLF;
in_reply_to = "In-Reply-To:" msg_id+ CRLF;
references = "References:" msg_id+ CRLF;

# 4.5.4 Obsolete Identification Fields
obs_message_id  = "Message-ID" WSP* ":" msg_id CRLF;
obs_in_reply_to = "In-Reply-To" WSP* ":" (phrase | msg_id)* CRLF;
obs_references  = "References" WSP* ":" (phrase | msg_id)* CRLF;

# 3.6.5 Informational Fields
# https://tools.ietf.org/html/rfc5322#section-3.6.5
subject = "Subject:" unstructured CRLF;
comments = "Comments:" unstructured CRLF;
keywords = "Keywords:" phrase ("," phrase)* CRLF;

# 4.5.5 Obsolete Informational Fields
# https://tools.ietf.org/html/rfc5322#section-4.5.5
obs_subject     =   "Subject" WSP* ":" unstructured CRLF;
obs_comments    =   "Comments" WSP* ":" unstructured CRLF;
obs_keywords    =   "Keywords" WSP* ":" obs_phrase_list CRLF;

# 3.6.6 Resent Fields
# https://tools.ietf.org/html/rfc5322#section-3.6.6
resent_date     =   "Resent-Date:" date_time CRLF;
resent_from     =   "Resent-From:" mailbox_list CRLF;
resent_sender   =   "Resent-Sender:" mailbox CRLF;
resent_to       =   "Resent-To:" address_list CRLF;
resent_cc       =   "Resent-Cc:" address_list CRLF;
resent_bcc      =   "Resent-Bcc:" (address_list | CFWS)? CRLF;
resent_msg_id   =   "Resent-Message-ID:" msg_id CRLF;

# 4.5.6 Obsolete Resent Fields
# https://tools.ietf.org/html/rfc5322#section-4.5.6
obs_resent_from =   "Resent-From" WSP* ":" mailbox_list CRLF;
obs_resent_send =   "Resent-Sender" WSP* ":" mailbox CRLF;
obs_resent_date =   "Resent-Date" WSP* ":" date_time CRLF;
obs_resent_to   =   "Resent-To" WSP* ":" address_list CRLF;
obs_resent_cc   =   "Resent-Cc" WSP* ":" address_list CRLF;
obs_resent_bcc  =   "Resent-Bcc" WSP* ":" (address_list | ((CFWS? ",")* CFWS?)) CRLF;
obs_resent_mid  =   "Resent-Message-ID" WSP* ":" msg_id CRLF;
obs_resent_rply =   "Resent-Reply-To" WSP* ":" address_list CRLF;

# 3.6.7 Trace Fields
# https://tools.ietf.org/html/rfc5322#section-3.6.7
# Added CFWS? to increase robustness (qmail likes to include a comment)
received_token = word | angle_addr | addr_spec_no_angle_brackets | domain;
received = ((CFWS? received_token*) >received_tokens_s %received_tokens_e)
            ";" date_time;
path = angle_addr | (CFWS? "<" CFWS? ">" CFWS?);
return = "Return-Path:" path CRLF;
trace = return? received+;

# 4.5.7 Obsolete Trace Fields
# https://tools.ietf.org/html/rfc5322#section-4.5.7
obs_return = "Return-Path" WSP* ":" path CRLF;
obs_received = "Received" WSP* ":" received_token* CRLF;

# 3.6.8 Optional Fields
# https://tools.ietf.org/html/rfc5322#section-3.6.8
ftext = 33..57 | 59..126; # Printable US-ASCII not including ":"
field_name = ftext+;
optional_field = field_name ":" unstructured CRLF;

# 4.5.8 Obsolete Optional Fields
# https://tools.ietf.org/html/rfc5322#section-4.5.8
obs_optional = field_name WSP* ":" unstructured CRLF;


# Envelope From
ctime_date = day_name " "+ month " "+ day " " time_of_day " " year;
null_sender = ('<>' ' '{0,1});
envelope_from = (addr_spec_no_angle_brackets | null_sender) >address_s %address_e " "
                (ctime_date >ctime_date_s %ctime_date_e);
}%%
