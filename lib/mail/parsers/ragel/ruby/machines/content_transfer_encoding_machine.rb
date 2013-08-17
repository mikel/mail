
# line 1 "/Users/peter/src/mail/lib/mail/parsers/ragel/ruby/machines/content_transfer_encoding_machine.rb.rl"

# line 10 "/Users/peter/src/mail/lib/mail/parsers/ragel/ruby/machines/content_transfer_encoding_machine.rb.rl"


module Mail
  module Parsers
    module Ragel
      module ContentTransferEncodingMachine
        
# line 13 "/Users/peter/src/mail/lib/mail/parsers/ragel/ruby/machines/content_transfer_encoding_machine.rb"
class << self
	attr_accessor :_content_transfer_encoding_trans_keys
	private :_content_transfer_encoding_trans_keys, :_content_transfer_encoding_trans_keys=
end
self._content_transfer_encoding_trans_keys = [
	0, 0, 9, 126, 10, 10, 
	9, 32, 10, 10, 9, 
	32, 10, 10, 9, 32, 
	9, 126, -128, 92, -128, -65, 
	-128, 92, -96, -65, -128, 
	-65, -128, -97, -112, -65, 
	-128, -65, -128, -113, 10, 10, 
	9, 32, -128, -12, -64, 
	92, -128, 92, -128, 92, 
	-128, 92, -128, 92, -128, 92, 
	-128, 92, 9, 126, 9, 
	59, 9, 59, 9, 40, 
	9, 40, 0, 0, 0
]

class << self
	attr_accessor :_content_transfer_encoding_key_spans
	private :_content_transfer_encoding_key_spans, :_content_transfer_encoding_key_spans=
end
self._content_transfer_encoding_key_spans = [
	0, 118, 1, 24, 1, 24, 1, 24, 
	118, 221, 64, 221, 32, 64, 32, 48, 
	64, 16, 1, 24, 117, 157, 221, 221, 
	221, 221, 221, 221, 118, 51, 51, 32, 
	32, 0
]

class << self
	attr_accessor :_content_transfer_encoding_index_offsets
	private :_content_transfer_encoding_index_offsets, :_content_transfer_encoding_index_offsets=
end
self._content_transfer_encoding_index_offsets = [
	0, 0, 119, 121, 146, 148, 173, 175, 
	200, 319, 541, 606, 828, 861, 926, 959, 
	1008, 1073, 1090, 1092, 1117, 1235, 1393, 1615, 
	1837, 2059, 2281, 2503, 2725, 2844, 2896, 2948, 
	2981, 3014
]

class << self
	attr_accessor :_content_transfer_encoding_indicies
	private :_content_transfer_encoding_indicies, :_content_transfer_encoding_indicies=
end
self._content_transfer_encoding_indicies = [
	0, 1, 1, 1, 2, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 0, 
	3, 3, 3, 3, 3, 3, 3, 4, 
	1, 3, 3, 3, 3, 3, 1, 3, 
	3, 3, 3, 3, 3, 3, 3, 3, 
	3, 1, 1, 1, 1, 1, 1, 1, 
	3, 3, 3, 3, 3, 3, 3, 3, 
	3, 3, 3, 3, 3, 3, 3, 3, 
	3, 3, 3, 3, 3, 3, 3, 3, 
	3, 3, 1, 1, 1, 3, 3, 3, 
	3, 3, 3, 3, 3, 3, 3, 3, 
	3, 3, 3, 3, 3, 3, 3, 3, 
	3, 3, 3, 3, 3, 3, 3, 3, 
	3, 3, 3, 3, 3, 3, 1, 5, 
	1, 0, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	0, 1, 6, 1, 7, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 7, 1, 8, 1, 9, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 9, 1, 
	10, 1, 1, 1, 11, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 10, 
	12, 12, 12, 12, 12, 12, 12, 13, 
	1, 12, 12, 12, 12, 12, 1, 12, 
	12, 12, 12, 12, 12, 12, 12, 12, 
	12, 1, 1, 1, 1, 1, 1, 1, 
	12, 12, 12, 12, 12, 12, 12, 12, 
	12, 12, 12, 12, 12, 12, 12, 12, 
	12, 12, 12, 12, 12, 12, 12, 12, 
	12, 12, 1, 1, 1, 12, 12, 12, 
	12, 12, 12, 12, 12, 12, 12, 12, 
	12, 12, 12, 12, 12, 12, 12, 12, 
	12, 12, 12, 12, 12, 12, 12, 12, 
	12, 12, 12, 12, 12, 12, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 14, 14, 14, 14, 14, 14, 14, 
	14, 14, 14, 14, 14, 14, 14, 14, 
	14, 14, 14, 14, 14, 14, 14, 14, 
	14, 14, 14, 14, 14, 14, 14, 15, 
	16, 16, 16, 16, 16, 16, 16, 16, 
	16, 16, 16, 16, 17, 16, 16, 18, 
	19, 19, 19, 20, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	21, 21, 21, 21, 21, 21, 21, 21, 
	21, 1, 21, 21, 22, 21, 21, 21, 
	21, 21, 21, 21, 21, 21, 21, 21, 
	21, 21, 21, 21, 21, 21, 21, 21, 
	21, 21, 21, 21, 21, 21, 21, 23, 
	24, 21, 21, 21, 21, 21, 21, 21, 
	21, 21, 21, 21, 21, 21, 21, 21, 
	21, 21, 21, 21, 21, 21, 21, 21, 
	21, 21, 21, 21, 21, 21, 21, 21, 
	21, 21, 21, 21, 21, 21, 21, 21, 
	21, 21, 21, 21, 21, 21, 21, 21, 
	21, 21, 21, 25, 21, 26, 26, 26, 
	26, 26, 26, 26, 26, 26, 26, 26, 
	26, 26, 26, 26, 26, 26, 26, 26, 
	26, 26, 26, 26, 26, 26, 26, 26, 
	26, 26, 26, 26, 26, 26, 26, 26, 
	26, 26, 26, 26, 26, 26, 26, 26, 
	26, 26, 26, 26, 26, 26, 26, 26, 
	26, 26, 26, 26, 26, 26, 26, 26, 
	26, 26, 26, 26, 26, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	27, 27, 27, 27, 27, 27, 27, 27, 
	27, 27, 27, 27, 27, 27, 27, 27, 
	27, 27, 27, 27, 27, 27, 27, 27, 
	27, 27, 27, 27, 27, 27, 28, 29, 
	29, 29, 29, 29, 29, 29, 29, 29, 
	29, 29, 29, 30, 29, 29, 31, 32, 
	32, 32, 33, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 26, 
	26, 26, 26, 26, 26, 26, 26, 26, 
	1, 26, 26, 34, 26, 26, 26, 26, 
	26, 26, 26, 26, 26, 26, 26, 26, 
	26, 26, 26, 26, 26, 26, 26, 26, 
	26, 26, 26, 26, 26, 26, 35, 36, 
	26, 26, 26, 26, 26, 26, 26, 26, 
	26, 26, 26, 26, 26, 26, 26, 26, 
	26, 26, 26, 26, 26, 26, 26, 26, 
	26, 26, 26, 26, 26, 26, 26, 26, 
	26, 26, 26, 26, 26, 26, 26, 26, 
	26, 26, 26, 26, 26, 26, 26, 26, 
	26, 26, 37, 26, 27, 27, 27, 27, 
	27, 27, 27, 27, 27, 27, 27, 27, 
	27, 27, 27, 27, 27, 27, 27, 27, 
	27, 27, 27, 27, 27, 27, 27, 27, 
	27, 27, 27, 27, 1, 27, 27, 27, 
	27, 27, 27, 27, 27, 27, 27, 27, 
	27, 27, 27, 27, 27, 27, 27, 27, 
	27, 27, 27, 27, 27, 27, 27, 27, 
	27, 27, 27, 27, 27, 27, 27, 27, 
	27, 27, 27, 27, 27, 27, 27, 27, 
	27, 27, 27, 27, 27, 27, 27, 27, 
	27, 27, 27, 27, 27, 27, 27, 27, 
	27, 27, 27, 27, 27, 1, 27, 27, 
	27, 27, 27, 27, 27, 27, 27, 27, 
	27, 27, 27, 27, 27, 27, 27, 27, 
	27, 27, 27, 27, 27, 27, 27, 27, 
	27, 27, 27, 27, 27, 27, 1, 29, 
	29, 29, 29, 29, 29, 29, 29, 29, 
	29, 29, 29, 29, 29, 29, 29, 29, 
	29, 29, 29, 29, 29, 29, 29, 29, 
	29, 29, 29, 29, 29, 29, 29, 29, 
	29, 29, 29, 29, 29, 29, 29, 29, 
	29, 29, 29, 29, 29, 29, 29, 1, 
	29, 29, 29, 29, 29, 29, 29, 29, 
	29, 29, 29, 29, 29, 29, 29, 29, 
	29, 29, 29, 29, 29, 29, 29, 29, 
	29, 29, 29, 29, 29, 29, 29, 29, 
	29, 29, 29, 29, 29, 29, 29, 29, 
	29, 29, 29, 29, 29, 29, 29, 29, 
	29, 29, 29, 29, 29, 29, 29, 29, 
	29, 29, 29, 29, 29, 29, 29, 29, 
	1, 29, 29, 29, 29, 29, 29, 29, 
	29, 29, 29, 29, 29, 29, 29, 29, 
	29, 1, 38, 1, 26, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 26, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 26, 26, 26, 
	26, 26, 26, 26, 26, 26, 26, 26, 
	26, 26, 26, 26, 26, 26, 26, 26, 
	26, 26, 26, 26, 26, 26, 26, 26, 
	26, 26, 26, 26, 26, 26, 26, 39, 
	39, 39, 39, 39, 39, 39, 39, 39, 
	39, 39, 39, 39, 39, 39, 39, 39, 
	39, 39, 39, 39, 39, 39, 39, 39, 
	39, 39, 39, 39, 39, 40, 41, 41, 
	41, 41, 41, 41, 41, 41, 41, 41, 
	41, 41, 42, 41, 41, 43, 44, 44, 
	44, 45, 26, 1, 1, 27, 27, 27, 
	27, 27, 27, 27, 27, 27, 27, 27, 
	27, 27, 27, 27, 27, 27, 27, 27, 
	27, 27, 27, 27, 27, 27, 27, 27, 
	27, 27, 27, 28, 29, 29, 29, 29, 
	29, 29, 29, 29, 29, 29, 29, 29, 
	30, 29, 29, 31, 32, 32, 32, 33, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 26, 26, 26, 26, 
	26, 26, 26, 26, 26, 1, 26, 26, 
	34, 26, 26, 26, 26, 26, 26, 26, 
	26, 26, 26, 26, 26, 26, 26, 26, 
	26, 26, 26, 26, 26, 26, 26, 26, 
	26, 26, 26, 35, 36, 26, 26, 26, 
	26, 26, 26, 26, 26, 26, 26, 26, 
	26, 26, 26, 26, 26, 26, 26, 26, 
	26, 26, 26, 26, 26, 26, 26, 26, 
	26, 26, 26, 26, 26, 26, 26, 26, 
	26, 26, 26, 26, 26, 26, 26, 26, 
	26, 26, 26, 26, 26, 26, 26, 37, 
	26, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 27, 27, 27, 27, 27, 27, 27, 
	27, 27, 27, 27, 27, 27, 27, 27, 
	27, 27, 27, 27, 27, 27, 27, 27, 
	27, 27, 27, 27, 27, 27, 27, 27, 
	27, 1, 1, 27, 27, 27, 27, 27, 
	27, 27, 27, 27, 27, 27, 27, 27, 
	27, 27, 27, 27, 27, 27, 27, 27, 
	27, 27, 27, 27, 27, 27, 27, 27, 
	27, 28, 29, 29, 29, 29, 29, 29, 
	29, 29, 29, 29, 29, 29, 30, 29, 
	29, 31, 32, 32, 32, 33, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 26, 26, 26, 26, 26, 26, 
	26, 26, 26, 1, 26, 26, 34, 26, 
	26, 26, 26, 26, 26, 26, 26, 26, 
	26, 26, 26, 26, 26, 26, 26, 26, 
	26, 26, 26, 26, 26, 26, 26, 26, 
	26, 35, 36, 26, 26, 26, 26, 26, 
	26, 26, 26, 26, 26, 26, 26, 26, 
	26, 26, 26, 26, 26, 26, 26, 26, 
	26, 26, 26, 26, 26, 26, 26, 26, 
	26, 26, 26, 26, 26, 26, 26, 26, 
	26, 26, 26, 26, 26, 26, 26, 26, 
	26, 26, 26, 26, 26, 37, 26, 27, 
	27, 27, 27, 27, 27, 27, 27, 27, 
	27, 27, 27, 27, 27, 27, 27, 27, 
	27, 27, 27, 27, 27, 27, 27, 27, 
	27, 27, 27, 27, 27, 27, 27, 27, 
	27, 27, 27, 27, 27, 27, 27, 27, 
	27, 27, 27, 27, 27, 27, 27, 27, 
	27, 27, 27, 27, 27, 27, 27, 27, 
	27, 27, 27, 27, 27, 27, 27, 1, 
	1, 27, 27, 27, 27, 27, 27, 27, 
	27, 27, 27, 27, 27, 27, 27, 27, 
	27, 27, 27, 27, 27, 27, 27, 27, 
	27, 27, 27, 27, 27, 27, 27, 28, 
	29, 29, 29, 29, 29, 29, 29, 29, 
	29, 29, 29, 29, 30, 29, 29, 31, 
	32, 32, 32, 33, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	26, 26, 26, 26, 26, 26, 26, 26, 
	26, 1, 26, 26, 34, 26, 26, 26, 
	26, 26, 26, 26, 26, 26, 26, 26, 
	26, 26, 26, 26, 26, 26, 26, 26, 
	26, 26, 26, 26, 26, 26, 26, 35, 
	36, 26, 26, 26, 26, 26, 26, 26, 
	26, 26, 26, 26, 26, 26, 26, 26, 
	26, 26, 26, 26, 26, 26, 26, 26, 
	26, 26, 26, 26, 26, 26, 26, 26, 
	26, 26, 26, 26, 26, 26, 26, 26, 
	26, 26, 26, 26, 26, 26, 26, 26, 
	26, 26, 26, 37, 26, 27, 27, 27, 
	27, 27, 27, 27, 27, 27, 27, 27, 
	27, 27, 27, 27, 27, 27, 27, 27, 
	27, 27, 27, 27, 27, 27, 27, 27, 
	27, 27, 27, 27, 27, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 27, 
	27, 27, 27, 27, 27, 27, 27, 27, 
	27, 27, 27, 27, 27, 27, 27, 27, 
	27, 27, 27, 27, 27, 27, 27, 27, 
	27, 27, 27, 27, 27, 28, 29, 29, 
	29, 29, 29, 29, 29, 29, 29, 29, 
	29, 29, 30, 29, 29, 31, 32, 32, 
	32, 33, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 26, 26, 
	26, 26, 26, 26, 26, 26, 26, 1, 
	26, 26, 34, 26, 26, 26, 26, 26, 
	26, 26, 26, 26, 26, 26, 26, 26, 
	26, 26, 26, 26, 26, 26, 26, 26, 
	26, 26, 26, 26, 26, 35, 36, 26, 
	26, 26, 26, 26, 26, 26, 26, 26, 
	26, 26, 26, 26, 26, 26, 26, 26, 
	26, 26, 26, 26, 26, 26, 26, 26, 
	26, 26, 26, 26, 26, 26, 26, 26, 
	26, 26, 26, 26, 26, 26, 26, 26, 
	26, 26, 26, 26, 26, 26, 26, 26, 
	26, 37, 26, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 29, 29, 29, 29, 29, 
	29, 29, 29, 29, 29, 29, 29, 29, 
	29, 29, 29, 29, 29, 29, 29, 29, 
	29, 29, 29, 29, 29, 29, 29, 29, 
	29, 29, 29, 29, 29, 29, 29, 29, 
	29, 29, 29, 29, 29, 29, 29, 29, 
	29, 29, 29, 1, 1, 27, 27, 27, 
	27, 27, 27, 27, 27, 27, 27, 27, 
	27, 27, 27, 27, 27, 27, 27, 27, 
	27, 27, 27, 27, 27, 27, 27, 27, 
	27, 27, 27, 28, 29, 29, 29, 29, 
	29, 29, 29, 29, 29, 29, 29, 29, 
	30, 29, 29, 31, 32, 32, 32, 33, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 26, 26, 26, 26, 
	26, 26, 26, 26, 26, 1, 26, 26, 
	34, 26, 26, 26, 26, 26, 26, 26, 
	26, 26, 26, 26, 26, 26, 26, 26, 
	26, 26, 26, 26, 26, 26, 26, 26, 
	26, 26, 26, 35, 36, 26, 26, 26, 
	26, 26, 26, 26, 26, 26, 26, 26, 
	26, 26, 26, 26, 26, 26, 26, 26, 
	26, 26, 26, 26, 26, 26, 26, 26, 
	26, 26, 26, 26, 26, 26, 26, 26, 
	26, 26, 26, 26, 26, 26, 26, 26, 
	26, 26, 26, 26, 26, 26, 26, 37, 
	26, 29, 29, 29, 29, 29, 29, 29, 
	29, 29, 29, 29, 29, 29, 29, 29, 
	29, 29, 29, 29, 29, 29, 29, 29, 
	29, 29, 29, 29, 29, 29, 29, 29, 
	29, 29, 29, 29, 29, 29, 29, 29, 
	29, 29, 29, 29, 29, 29, 29, 29, 
	29, 29, 29, 29, 29, 29, 29, 29, 
	29, 29, 29, 29, 29, 29, 29, 29, 
	29, 1, 1, 27, 27, 27, 27, 27, 
	27, 27, 27, 27, 27, 27, 27, 27, 
	27, 27, 27, 27, 27, 27, 27, 27, 
	27, 27, 27, 27, 27, 27, 27, 27, 
	27, 28, 29, 29, 29, 29, 29, 29, 
	29, 29, 29, 29, 29, 29, 30, 29, 
	29, 31, 32, 32, 32, 33, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 26, 26, 26, 26, 26, 26, 
	26, 26, 26, 1, 26, 26, 34, 26, 
	26, 26, 26, 26, 26, 26, 26, 26, 
	26, 26, 26, 26, 26, 26, 26, 26, 
	26, 26, 26, 26, 26, 26, 26, 26, 
	26, 35, 36, 26, 26, 26, 26, 26, 
	26, 26, 26, 26, 26, 26, 26, 26, 
	26, 26, 26, 26, 26, 26, 26, 26, 
	26, 26, 26, 26, 26, 26, 26, 26, 
	26, 26, 26, 26, 26, 26, 26, 26, 
	26, 26, 26, 26, 26, 26, 26, 26, 
	26, 26, 26, 26, 26, 37, 26, 29, 
	29, 29, 29, 29, 29, 29, 29, 29, 
	29, 29, 29, 29, 29, 29, 29, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 27, 27, 27, 27, 27, 27, 27, 
	27, 27, 27, 27, 27, 27, 27, 27, 
	27, 27, 27, 27, 27, 27, 27, 27, 
	27, 27, 27, 27, 27, 27, 27, 28, 
	29, 29, 29, 29, 29, 29, 29, 29, 
	29, 29, 29, 29, 30, 29, 29, 31, 
	32, 32, 32, 33, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	26, 26, 26, 26, 26, 26, 26, 26, 
	26, 1, 26, 26, 34, 26, 26, 26, 
	26, 26, 26, 26, 26, 26, 26, 26, 
	26, 26, 26, 26, 26, 26, 26, 26, 
	26, 26, 26, 26, 26, 26, 26, 35, 
	36, 26, 26, 26, 26, 26, 26, 26, 
	26, 26, 26, 26, 26, 26, 26, 26, 
	26, 26, 26, 26, 26, 26, 26, 26, 
	26, 26, 26, 26, 26, 26, 26, 26, 
	26, 26, 26, 26, 26, 26, 26, 26, 
	26, 26, 26, 26, 26, 26, 26, 26, 
	26, 26, 26, 37, 26, 46, 1, 1, 
	1, 47, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 46, 48, 48, 48, 
	48, 48, 48, 48, 49, 1, 48, 48, 
	48, 48, 48, 1, 48, 48, 48, 48, 
	48, 48, 48, 48, 48, 48, 1, 50, 
	1, 1, 1, 1, 1, 48, 48, 48, 
	48, 48, 48, 48, 48, 48, 48, 48, 
	48, 48, 48, 48, 48, 48, 48, 48, 
	48, 48, 48, 48, 48, 48, 48, 1, 
	1, 1, 48, 48, 48, 48, 48, 48, 
	48, 48, 48, 48, 48, 48, 48, 48, 
	48, 48, 48, 48, 48, 48, 48, 48, 
	48, 48, 48, 48, 48, 48, 48, 48, 
	48, 48, 48, 1, 7, 1, 1, 1, 
	51, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 7, 1, 1, 1, 1, 
	1, 1, 1, 52, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 9, 1, 
	53, 1, 1, 1, 54, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 53, 
	1, 1, 1, 1, 1, 1, 1, 55, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 56, 1, 9, 1, 1, 1, 
	57, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 9, 1, 1, 1, 1, 
	1, 1, 1, 58, 1, 56, 1, 1, 
	1, 59, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 56, 1, 1, 1, 
	1, 1, 1, 1, 60, 1, 1, 0
]

class << self
	attr_accessor :_content_transfer_encoding_trans_targs
	private :_content_transfer_encoding_trans_targs, :_content_transfer_encoding_trans_targs=
end
self._content_transfer_encoding_trans_targs = [
	1, 0, 2, 28, 8, 3, 5, 29, 
	7, 31, 1, 2, 28, 8, 10, 12, 
	13, 14, 15, 16, 17, 11, 18, 11, 
	33, 20, 11, 10, 12, 13, 14, 15, 
	16, 17, 18, 11, 33, 20, 19, 21, 
	22, 23, 24, 25, 26, 27, 29, 4, 
	28, 30, 31, 4, 30, 29, 4, 30, 
	31, 6, 32, 6, 32
]

class << self
	attr_accessor :_content_transfer_encoding_trans_actions
	private :_content_transfer_encoding_trans_actions, :_content_transfer_encoding_trans_actions=
end
self._content_transfer_encoding_trans_actions = [
	0, 0, 0, 1, 2, 0, 0, 0, 
	0, 0, 3, 3, 4, 5, 6, 6, 
	6, 6, 6, 6, 6, 6, 6, 7, 
	8, 6, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 2, 9, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 10, 10, 
	0, 11, 10, 0, 2, 3, 3, 5, 
	3, 0, 2, 3, 5
]

class << self
	attr_accessor :_content_transfer_encoding_eof_actions
	private :_content_transfer_encoding_eof_actions, :_content_transfer_encoding_eof_actions=
end
self._content_transfer_encoding_eof_actions = [
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 10, 0, 3, 0, 
	3, 0
]

class << self
	attr_accessor :content_transfer_encoding_start
end
self.content_transfer_encoding_start = 1;
class << self
	attr_accessor :content_transfer_encoding_first_final
end
self.content_transfer_encoding_first_final = 28;
class << self
	attr_accessor :content_transfer_encoding_error
end
self.content_transfer_encoding_error = 0;

class << self
	attr_accessor :content_transfer_encoding_en_comment_tail
end
self.content_transfer_encoding_en_comment_tail = 9;
class << self
	attr_accessor :content_transfer_encoding_en_main
end
self.content_transfer_encoding_en_main = 1;


# line 17 "/Users/peter/src/mail/lib/mail/parsers/ragel/ruby/machines/content_transfer_encoding_machine.rb.rl"

        def self.parse(data)
          p = 0
          eof = data.length
          stack = []

          actions = []
          data_unpacked = data.bytes.to_a
          
# line 517 "/Users/peter/src/mail/lib/mail/parsers/ragel/ruby/machines/content_transfer_encoding_machine.rb"
begin
	p ||= 0
	pe ||= data.length
	cs = content_transfer_encoding_start
	top = 0
end

# line 26 "/Users/peter/src/mail/lib/mail/parsers/ragel/ruby/machines/content_transfer_encoding_machine.rb.rl"
          
# line 527 "/Users/peter/src/mail/lib/mail/parsers/ragel/ruby/machines/content_transfer_encoding_machine.rb"
begin
	testEof = false
	_slen, _trans, _keys, _inds, _acts, _nacts = nil
	_goto_level = 0
	_resume = 10
	_eof_trans = 15
	_again = 20
	_test_eof = 30
	_out = 40
	while true
	if _goto_level <= 0
	if p == pe
		_goto_level = _test_eof
		next
	end
	if cs == 0
		_goto_level = _out
		next
	end
	end
	if _goto_level <= _resume
	_keys = cs << 1
	_inds = _content_transfer_encoding_index_offsets[cs]
	_slen = _content_transfer_encoding_key_spans[cs]
	_trans = if (   _slen > 0 && 
			_content_transfer_encoding_trans_keys[_keys] <= ( data_unpacked[p]) && 
			( data_unpacked[p]) <= _content_transfer_encoding_trans_keys[_keys + 1] 
		    ) then
			_content_transfer_encoding_indicies[ _inds + ( data_unpacked[p]) - _content_transfer_encoding_trans_keys[_keys] ] 
		 else 
			_content_transfer_encoding_indicies[ _inds + _slen ]
		 end
	cs = _content_transfer_encoding_trans_targs[_trans]
	if _content_transfer_encoding_trans_actions[_trans] != 0
	case _content_transfer_encoding_trans_actions[_trans]
	when 3 then
# line 7 "/Users/peter/src/mail/lib/mail/parsers/ragel/ruby/machines/rb_actions.rl"
		begin
 actions.push(4, p) 		end
	when 6 then
# line 8 "/Users/peter/src/mail/lib/mail/parsers/ragel/ruby/machines/rb_actions.rl"
		begin
 actions.push(5, p) 		end
	when 10 then
# line 17 "/Users/peter/src/mail/lib/mail/parsers/ragel/ruby/machines/rb_actions.rl"
		begin
 actions.push(14, p) 		end
	when 1 then
# line 18 "/Users/peter/src/mail/lib/mail/parsers/ragel/ruby/machines/rb_actions.rl"
		begin
 actions.push(15, p) 		end
	when 2 then
# line 5 "/Users/peter/src/mail/lib/mail/parsers/ragel/ruby/machines/../../common.rl"
		begin
 	begin
		stack[top] = cs
		top+= 1
		cs = 9
		_goto_level = _again
		next
	end
 		end
	when 9 then
# line 6 "/Users/peter/src/mail/lib/mail/parsers/ragel/ruby/machines/../../common.rl"
		begin
 	begin
		top -= 1
		cs = stack[top]
		_goto_level = _again
		next
	end
 		end
	when 4 then
# line 7 "/Users/peter/src/mail/lib/mail/parsers/ragel/ruby/machines/rb_actions.rl"
		begin
 actions.push(4, p) 		end
# line 18 "/Users/peter/src/mail/lib/mail/parsers/ragel/ruby/machines/rb_actions.rl"
		begin
 actions.push(15, p) 		end
	when 5 then
# line 7 "/Users/peter/src/mail/lib/mail/parsers/ragel/ruby/machines/rb_actions.rl"
		begin
 actions.push(4, p) 		end
# line 5 "/Users/peter/src/mail/lib/mail/parsers/ragel/ruby/machines/../../common.rl"
		begin
 	begin
		stack[top] = cs
		top+= 1
		cs = 9
		_goto_level = _again
		next
	end
 		end
	when 7 then
# line 8 "/Users/peter/src/mail/lib/mail/parsers/ragel/ruby/machines/rb_actions.rl"
		begin
 actions.push(5, p) 		end
# line 5 "/Users/peter/src/mail/lib/mail/parsers/ragel/ruby/machines/../../common.rl"
		begin
 	begin
		stack[top] = cs
		top+= 1
		cs = 9
		_goto_level = _again
		next
	end
 		end
	when 8 then
# line 8 "/Users/peter/src/mail/lib/mail/parsers/ragel/ruby/machines/rb_actions.rl"
		begin
 actions.push(5, p) 		end
# line 6 "/Users/peter/src/mail/lib/mail/parsers/ragel/ruby/machines/../../common.rl"
		begin
 	begin
		top -= 1
		cs = stack[top]
		_goto_level = _again
		next
	end
 		end
	when 11 then
# line 17 "/Users/peter/src/mail/lib/mail/parsers/ragel/ruby/machines/rb_actions.rl"
		begin
 actions.push(14, p) 		end
# line 5 "/Users/peter/src/mail/lib/mail/parsers/ragel/ruby/machines/../../common.rl"
		begin
 	begin
		stack[top] = cs
		top+= 1
		cs = 9
		_goto_level = _again
		next
	end
 		end
# line 662 "/Users/peter/src/mail/lib/mail/parsers/ragel/ruby/machines/content_transfer_encoding_machine.rb"
	end
	end
	end
	if _goto_level <= _again
	if cs == 0
		_goto_level = _out
		next
	end
	p += 1
	if p != pe
		_goto_level = _resume
		next
	end
	end
	if _goto_level <= _test_eof
	if p == eof
	  case _content_transfer_encoding_eof_actions[cs]
	when 3 then
# line 7 "/Users/peter/src/mail/lib/mail/parsers/ragel/ruby/machines/rb_actions.rl"
		begin
 actions.push(4, p) 		end
	when 10 then
# line 17 "/Users/peter/src/mail/lib/mail/parsers/ragel/ruby/machines/rb_actions.rl"
		begin
 actions.push(14, p) 		end
# line 688 "/Users/peter/src/mail/lib/mail/parsers/ragel/ruby/machines/content_transfer_encoding_machine.rb"
	  end
	end

	end
	if _goto_level <= _out
		break
	end
end
	end

# line 27 "/Users/peter/src/mail/lib/mail/parsers/ragel/ruby/machines/content_transfer_encoding_machine.rb.rl"

          if p == eof && cs >= 
# line 702 "/Users/peter/src/mail/lib/mail/parsers/ragel/ruby/machines/content_transfer_encoding_machine.rb"
28
# line 28 "/Users/peter/src/mail/lib/mail/parsers/ragel/ruby/machines/content_transfer_encoding_machine.rb.rl"

            return actions, nil
          else
            return [], "Only able to parse up to #{data[0..p]}"
          end
        end
      end
    end
  end
end
