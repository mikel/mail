%%{
  # RFC 5234 B.1. Core Rules
  # https://tools.ietf.org/html/rfc5234#appendix-B.1
  machine rfc5234_abnf_core_rules;

  LF = "\n";
  CR = "\r";
  CRLF = "\r\n";
  SP = " ";
  HTAB = "\t";
  WSP = SP | HTAB;
  DQUOTE = '"';
  DIGIT = [0-9];
  ALPHA = [a-zA-Z];
  VCHAR = 0x21..0x7e;
}%%
