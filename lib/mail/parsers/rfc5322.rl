%%{
# RFC 5322 Internet Message Format
# https://tools.ietf.org/html/rfc5322
# https://www.rfc-editor.org/errata_search.php?rfc=5322
#
# RFC 6854 Update to Internet Message Format to Allow Group Syntax in the "From:" and "Sender:" Header Fields
# https://tools.ietf.org/html/rfc6854
machine rfc5322;
alphtype int;

include rfc5234_abnf_core_rules "rfc5234_abnf_core_rules.rl";

# 3.2. Lexical Tokens
include rfc5322_lexical_tokens "rfc5322_lexical_tokens.rl";

# 3.3. Date and Time Specification
include rfc5322_date_time "rfc5322_date_time.rl";

# 3.4. Address Specification
include rfc5322_address "rfc5322_address.rl";

# 3.6. Field Definitions
include rfc5322_fields "rfc5322_fields.rl";

# 3.5. Overall Message Syntax
include rfc5322_message "rfc5322_message.rl";
}%%
