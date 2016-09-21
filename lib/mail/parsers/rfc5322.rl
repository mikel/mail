%%{
  # RFC 5322 Internet Message Format
  # https://tools.ietf.org/html/rfc5322
  #
  # RFC 6854 Update to Internet Message Format to Allow Group Syntax in the "From:" and "Sender:" Header Fields
  # https://tools.ietf.org/html/rfc6854
  machine rfc5322;

  include rfc5234_abnf_core_rules "rfc5234_abnf_core_rules.rl";

  # 3.2. Lexical Tokens
  include rfc5322_lexical_tokens "rfc5322_lexical_tokens.rl";

  # 3.3. Date and Time Specification
  include rfc5322_date_time "rfc5322_date_time.rl";

  # 3.4. Address Specification
  include rfc5322_address "rfc5322_address.rl";

  # 3.5. Overall Message Syntax
  #text = 0x01..0x09 | "\v" | "\f" | 0x0e..0x1f;
  #obs_body = ((LF* CR* ((0x00 | text) LF* CR*)*) | CRLF)*
  #body = ((text{,998} CRLF)* text{,998}) | obs_body;
  #message = (fields | obs_fields) (CRLF body)?;


  # 3.6. Field Definitions

  # 3.6.4. Identification Fields
  obs_id_left = local_part;
  id_left = dot_atom_text | obs_id_left;
  # id_right modifications to support multiple '@' in msg_id.
  msg_id_atext = ALPHA | DIGIT | "!" | "#" | "$" | "%" | "&" | "'" | "*" |
                 "+" | "-" | "/" | "=" | "?" | "^" | "_" | "`" | "{" | "|" |
                 "}" | "~" | "@";
  msg_id_dot_atom_text = (msg_id_atext+ "."?)+;
  obs_id_right = domain;
  no_fold_literal = "[" (dtext)* "]";
  id_right = msg_id_dot_atom_text | no_fold_literal | obs_id_right;
  msg_id = (CFWS)?
           (("<" id_left "@" id_right ">") >msg_id_s %msg_id_e)
           (CFWS)?;
  message_ids = msg_id (CFWS? msg_id)*;


  # 3.6.7 Trace Fields
  # Added CFWS? to increase robustness (qmail likes to include a comment)
  received_token = word | angle_addr | addr_spec_no_angle_brackets | domain;
  received = ((CFWS? received_token*) >received_tokens_s %received_tokens_e)
              ";" date_time;


  # RFC2045: mime_version, content_type, content_transfer_encoding
  mime_version = CFWS?
            (DIGIT+ >major_digits_s %major_digits_e)
            comment? "." comment?
            (DIGIT+ >minor_digits_s %minor_digits_e)
            CFWS?;

  token = 0x21..0x27 | 0x2a..0x2b | 0x2c..0x2e |
          0x30..0x39 | 0x41..0x5a | 0x5e..0x7e;
  value = (quoted_string | (token -- '"' | 0x3d)+) >param_val_s %param_val_e;
  attribute = (token+) >param_attr_s %param_attr_e;
  parameter = CFWS? attribute "=" value CFWS?;

  ietf_token = token+;
  custom_x_token = 'x'i "-" token+;
  extension_token = ietf_token | custom_x_token;
  discrete_type = 'text'i | 'image'i | 'audio'i | 'video'i |
                  'application'i | extension_token;
  composite_type = 'message'i | 'multipart'i | extension_token;
  iana_token = token+;
  main_type = (discrete_type | composite_type) >main_type_s %main_type_e;
  sub_type = (extension_token | iana_token) >sub_type_s %sub_type_e;
  content_type = main_type "/" sub_type (((CFWS? ";"+) | CFWS) parameter CFWS?)*;

  encoding = ('7bits' | '8bits' | '7bit' | '8bit' | 'binary' |
              'quoted-printable' | 'base64' | ietf_token |
              custom_x_token) >encoding_s %encoding_e;
  content_transfer_encoding = CFWS? encoding CFWS? ";"? CFWS?;

  # RFC2183: content_disposition
  # TODO: recognize filename, size, creation date, etc.
  disposition_type = 'inline'i | 'attachment'i | extension_token | '';
  content_disposition = (disposition_type >disp_type_s %disp_type_e)
                        (CFWS? ";" parameter CFWS?)*;

  # Envelope From
  ctime_date = day_name " "+ month " "+ day " " time_of_day " " year;
  null_sender = ('<>' ' '{0,1});
  envelope_from = (addr_spec_no_angle_brackets | null_sender) >address_s %address_e " "
                  (ctime_date >ctime_date_s %ctime_date_e);

  # content_location
  location = quoted_string | ((token | 0x3d)+ >token_string_s %token_string_e);
  content_location = CFWS? location CFWS?;
}%%
