%%{

# RFC 5322 Section 3.5 Overall Message Syntax
# https://tools.ietf.org/html/rfc5322#section-3.5
machine rfc5322_message;
alphtype int;

include rfc3629_utf8 "rfc3629_utf8.rl";
include rfc5322_fields "rfc5322_fields.rl";

rfc5322_text = 0x01..0x09 | "\v" | "\f" | 0x0e..0x7f;
text = rfc5322_text | utf8_non_ascii; # RFC6532 for UTF-8

#obs_body = ((LF* CR* ((0x00 | text) LF* CR*)*) | CRLF)*;
obs_body = (0x00 | text | LF | CR)*; # Erratum 1906
body = ((text{,998} CRLF)* text{,998}) | obs_body;

fields =
(
  trace optional_field* |
  (
    resent_date |
    resent_from |
    resent_sender |
    resent_to |
    resent_cc |
    resent_bcc |
    resent_msg_id
  )+
)*
(
  orig_date |
  from_field |
  sender |
  reply_to |
  to_field |
  cc |
  bcc |
  message_id |
  in_reply_to |
  references |
  subject |
  comments |
  keywords |
  optional_field
)*;

obs_fields = (
  obs_return |
  obs_received |
  obs_orig_date |
  obs_from |
  obs_sender |
  obs_reply_to |
  obs_to |
  obs_cc |
  obs_bcc |
  obs_message_id |
  obs_in_reply_to |
  obs_references |
  obs_subject |
  obs_comments |
  obs_keywords |
  obs_resent_date |
  obs_resent_from |
  obs_resent_send |
  obs_resent_rply |
  obs_resent_to |
  obs_resent_cc |
  obs_resent_bcc |
  obs_resent_mid |
  obs_optional
)*;

message = (fields | obs_fields) (CRLF body)?;
}%%
