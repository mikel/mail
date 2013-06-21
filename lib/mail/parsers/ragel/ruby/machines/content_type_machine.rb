
# line 1 "/0/ruby/mail/lib/mail/parsers/ragel/ruby/machines/content_type_machine.rb.rl"

# line 10 "/0/ruby/mail/lib/mail/parsers/ragel/ruby/machines/content_type_machine.rb.rl"


module Mail
  module Parsers
    module Ragel
      module ContentTypeMachine
        
# line 13 "/0/ruby/mail/lib/mail/parsers/ragel/ruby/machines/content_type_machine.rb"
class << self
	attr_accessor :_content_type_trans_keys
	private :_content_type_trans_keys, :_content_type_trans_keys=
end
self._content_type_trans_keys = [
	0, 0, 33, 126, 33, 126, 
	33, 126, 9, 126, 10, 
	10, 9, 32, 33, 126, 
	33, 126, 10, 10, 9, 32, 
	9, 126, 9, 126, 10, 
	10, 9, 32, 9, 126, 
	1, 127, 1, 127, 10, 10, 
	9, 32, 0, 127, 9, 
	126, 1, 127, 1, 127, 
	10, 10, 9, 32, -128, -1, 
	9, 126, 9, 126, 9, 
	126, 9, 126, 9, 59, 
	0, 0, 0
]

class << self
	attr_accessor :_content_type_key_spans
	private :_content_type_key_spans, :_content_type_key_spans=
end
self._content_type_key_spans = [
	0, 94, 94, 94, 118, 1, 24, 94, 
	94, 1, 24, 118, 118, 1, 24, 118, 
	127, 127, 1, 24, 128, 118, 127, 127, 
	1, 24, 128, 118, 118, 118, 118, 51, 
	0
]

class << self
	attr_accessor :_content_type_index_offsets
	private :_content_type_index_offsets, :_content_type_index_offsets=
end
self._content_type_index_offsets = [
	0, 0, 95, 190, 285, 404, 406, 431, 
	526, 621, 623, 648, 767, 886, 888, 913, 
	1032, 1160, 1288, 1290, 1315, 1444, 1563, 1691, 
	1819, 1821, 1846, 1975, 2094, 2213, 2332, 2451, 
	2503
]

class << self
	attr_accessor :_content_type_indicies
	private :_content_type_indicies, :_content_type_indicies=
end
self._content_type_indicies = [
	0, 0, 0, 0, 0, 0, 0, 1, 
	1, 0, 0, 0, 0, 0, 1, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 1, 1, 1, 1, 1, 1, 1, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 1, 1, 1, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 1, 2, 
	2, 2, 2, 2, 2, 2, 1, 1, 
	2, 2, 2, 2, 2, 3, 2, 2, 
	2, 2, 2, 2, 2, 2, 2, 2, 
	1, 1, 1, 1, 1, 1, 1, 2, 
	2, 2, 2, 2, 2, 2, 2, 2, 
	2, 2, 2, 2, 2, 2, 2, 2, 
	2, 2, 2, 2, 2, 2, 2, 2, 
	2, 1, 1, 1, 2, 2, 2, 2, 
	2, 2, 2, 2, 2, 2, 2, 2, 
	2, 2, 2, 2, 2, 2, 2, 2, 
	2, 2, 2, 2, 2, 2, 2, 2, 
	2, 2, 2, 2, 2, 1, 4, 4, 
	4, 4, 4, 4, 4, 1, 1, 4, 
	4, 4, 4, 4, 1, 4, 4, 4, 
	4, 4, 4, 4, 4, 4, 4, 1, 
	1, 1, 1, 1, 1, 1, 4, 4, 
	4, 4, 4, 4, 4, 4, 4, 4, 
	4, 4, 4, 4, 4, 4, 4, 4, 
	4, 4, 4, 4, 4, 4, 4, 4, 
	1, 1, 1, 4, 4, 4, 4, 4, 
	4, 4, 4, 4, 4, 4, 4, 4, 
	4, 4, 4, 4, 4, 4, 4, 4, 
	4, 4, 4, 4, 4, 4, 4, 4, 
	4, 4, 4, 4, 1, 5, 1, 1, 
	1, 6, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 5, 7, 7, 7, 
	7, 7, 7, 7, 8, 1, 7, 7, 
	7, 7, 7, 1, 7, 7, 7, 7, 
	7, 7, 7, 7, 7, 7, 1, 9, 
	1, 1, 1, 1, 1, 7, 7, 7, 
	7, 7, 7, 7, 7, 7, 7, 7, 
	7, 7, 7, 7, 7, 7, 7, 7, 
	7, 7, 7, 7, 7, 7, 7, 1, 
	1, 1, 7, 7, 7, 7, 7, 7, 
	7, 7, 7, 7, 7, 7, 7, 7, 
	7, 7, 7, 7, 7, 7, 7, 7, 
	7, 7, 7, 7, 7, 7, 7, 7, 
	7, 7, 7, 1, 10, 1, 5, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 5, 1, 11, 
	11, 11, 11, 11, 11, 11, 1, 1, 
	11, 11, 11, 11, 11, 1, 11, 11, 
	11, 11, 11, 11, 11, 11, 11, 11, 
	1, 1, 1, 12, 1, 1, 1, 11, 
	11, 11, 11, 11, 11, 11, 11, 11, 
	11, 11, 11, 11, 11, 11, 11, 11, 
	11, 11, 11, 11, 11, 11, 11, 11, 
	11, 1, 1, 1, 11, 11, 11, 11, 
	11, 11, 11, 11, 11, 11, 11, 11, 
	11, 11, 11, 11, 11, 11, 11, 11, 
	11, 11, 11, 11, 11, 11, 11, 11, 
	11, 11, 11, 11, 11, 1, 13, 14, 
	13, 13, 13, 13, 13, 1, 1, 13, 
	13, 13, 13, 13, 1, 13, 13, 13, 
	13, 13, 13, 13, 13, 13, 13, 1, 
	1, 1, 13, 1, 1, 1, 13, 13, 
	13, 13, 13, 13, 13, 13, 13, 13, 
	13, 13, 13, 13, 13, 13, 13, 13, 
	13, 13, 13, 13, 13, 13, 13, 13, 
	1, 1, 1, 13, 13, 13, 13, 13, 
	13, 13, 13, 13, 13, 13, 13, 13, 
	13, 13, 13, 13, 13, 13, 13, 13, 
	13, 13, 13, 13, 13, 13, 13, 13, 
	13, 13, 13, 13, 1, 15, 1, 16, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 16, 1, 
	17, 1, 1, 1, 18, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 17, 
	7, 7, 7, 7, 7, 7, 7, 19, 
	1, 7, 7, 7, 7, 7, 1, 7, 
	7, 7, 7, 7, 7, 7, 7, 7, 
	7, 1, 9, 1, 1, 1, 1, 1, 
	7, 7, 7, 7, 7, 7, 7, 7, 
	7, 7, 7, 7, 7, 7, 7, 7, 
	7, 7, 7, 7, 7, 7, 7, 7, 
	7, 7, 1, 1, 1, 7, 7, 7, 
	7, 7, 7, 7, 7, 7, 7, 7, 
	7, 7, 7, 7, 7, 7, 7, 7, 
	7, 7, 7, 7, 7, 7, 7, 7, 
	7, 7, 7, 7, 7, 7, 1, 17, 
	1, 1, 1, 18, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 17, 7, 
	7, 7, 7, 7, 7, 7, 19, 1, 
	7, 7, 7, 7, 7, 1, 7, 7, 
	7, 7, 7, 7, 7, 7, 7, 7, 
	1, 1, 1, 1, 1, 1, 1, 7, 
	7, 7, 7, 7, 7, 7, 7, 7, 
	7, 7, 7, 7, 7, 7, 7, 7, 
	7, 7, 7, 7, 7, 7, 7, 7, 
	7, 1, 1, 1, 7, 7, 7, 7, 
	7, 7, 7, 7, 7, 7, 7, 7, 
	7, 7, 7, 7, 7, 7, 7, 7, 
	7, 7, 7, 7, 7, 7, 7, 7, 
	7, 7, 7, 7, 7, 1, 20, 1, 
	17, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 17, 
	1, 21, 1, 1, 1, 22, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	21, 23, 23, 23, 23, 23, 23, 23, 
	24, 1, 23, 23, 23, 23, 23, 1, 
	23, 23, 23, 23, 23, 23, 23, 23, 
	23, 23, 1, 1, 1, 1, 1, 1, 
	1, 23, 23, 23, 23, 23, 23, 23, 
	23, 23, 23, 23, 23, 23, 23, 23, 
	23, 23, 23, 23, 23, 23, 23, 23, 
	23, 23, 23, 1, 1, 1, 23, 23, 
	23, 23, 23, 23, 23, 23, 23, 23, 
	23, 23, 23, 23, 23, 23, 23, 23, 
	23, 23, 23, 23, 23, 23, 23, 23, 
	23, 23, 23, 23, 23, 23, 23, 1, 
	25, 25, 25, 25, 25, 25, 25, 25, 
	25, 1, 25, 25, 26, 25, 25, 25, 
	25, 25, 25, 25, 25, 25, 25, 25, 
	25, 25, 25, 25, 25, 25, 25, 25, 
	25, 27, 25, 25, 25, 25, 25, 25, 
	25, 25, 25, 25, 25, 25, 25, 25, 
	25, 25, 25, 25, 25, 25, 25, 25, 
	25, 25, 25, 25, 25, 25, 25, 25, 
	25, 25, 25, 25, 25, 25, 25, 25, 
	25, 25, 25, 25, 25, 25, 25, 25, 
	25, 25, 25, 25, 25, 25, 25, 25, 
	25, 25, 25, 28, 25, 25, 25, 25, 
	25, 25, 25, 25, 25, 25, 25, 25, 
	25, 25, 25, 25, 25, 25, 25, 25, 
	25, 25, 25, 25, 25, 25, 25, 25, 
	25, 25, 25, 25, 25, 25, 25, 1, 
	29, 29, 29, 29, 29, 29, 29, 29, 
	29, 1, 29, 29, 30, 29, 29, 29, 
	29, 29, 29, 29, 29, 29, 29, 29, 
	29, 29, 29, 29, 29, 29, 29, 29, 
	29, 31, 29, 29, 29, 29, 29, 29, 
	29, 29, 29, 29, 29, 29, 29, 29, 
	29, 29, 29, 29, 29, 29, 29, 29, 
	29, 29, 29, 29, 29, 29, 29, 29, 
	29, 29, 29, 29, 29, 29, 29, 29, 
	29, 29, 29, 29, 29, 29, 29, 29, 
	29, 29, 29, 29, 29, 29, 29, 29, 
	29, 29, 29, 32, 29, 29, 29, 29, 
	29, 29, 29, 29, 29, 29, 29, 29, 
	29, 29, 29, 29, 29, 29, 29, 29, 
	29, 29, 29, 29, 29, 29, 29, 29, 
	29, 29, 29, 29, 29, 29, 29, 1, 
	33, 1, 29, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 29, 1, 29, 29, 29, 29, 29, 
	29, 29, 29, 29, 29, 29, 29, 29, 
	29, 29, 29, 29, 29, 29, 29, 29, 
	29, 29, 29, 29, 29, 29, 29, 29, 
	29, 29, 29, 29, 29, 29, 29, 29, 
	29, 29, 29, 29, 29, 29, 29, 29, 
	29, 29, 29, 29, 29, 29, 29, 29, 
	29, 29, 29, 29, 29, 29, 29, 29, 
	29, 29, 29, 29, 29, 29, 29, 29, 
	29, 29, 29, 29, 29, 29, 29, 29, 
	29, 29, 29, 29, 29, 29, 29, 29, 
	29, 29, 29, 29, 29, 29, 29, 29, 
	29, 29, 29, 29, 29, 29, 29, 29, 
	29, 29, 29, 29, 29, 29, 29, 29, 
	29, 29, 29, 29, 29, 29, 29, 29, 
	29, 29, 29, 29, 29, 29, 29, 29, 
	29, 29, 29, 1, 34, 1, 1, 1, 
	35, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 34, 23, 23, 23, 23, 
	23, 23, 23, 36, 1, 23, 23, 23, 
	23, 23, 1, 23, 23, 23, 23, 23, 
	23, 23, 23, 23, 23, 1, 37, 1, 
	1, 1, 1, 1, 23, 23, 23, 23, 
	23, 23, 23, 23, 23, 23, 23, 23, 
	23, 23, 23, 23, 23, 23, 23, 23, 
	23, 23, 23, 23, 23, 23, 1, 1, 
	1, 23, 23, 23, 23, 23, 23, 23, 
	23, 23, 23, 23, 23, 23, 23, 23, 
	23, 23, 23, 23, 23, 23, 23, 23, 
	23, 23, 23, 23, 23, 23, 23, 23, 
	23, 23, 1, 38, 38, 38, 38, 38, 
	38, 38, 38, 38, 1, 38, 38, 39, 
	38, 38, 38, 38, 38, 38, 38, 38, 
	38, 38, 38, 38, 38, 38, 38, 38, 
	38, 38, 38, 38, 38, 38, 38, 38, 
	38, 38, 40, 41, 38, 38, 38, 38, 
	38, 38, 38, 38, 38, 38, 38, 38, 
	38, 38, 38, 38, 38, 38, 38, 38, 
	38, 38, 38, 38, 38, 38, 38, 38, 
	38, 38, 38, 38, 38, 38, 38, 38, 
	38, 38, 38, 38, 38, 38, 38, 38, 
	38, 38, 38, 38, 38, 38, 42, 38, 
	38, 38, 38, 38, 38, 38, 38, 38, 
	38, 38, 38, 38, 38, 38, 38, 38, 
	38, 38, 38, 38, 38, 38, 38, 38, 
	38, 38, 38, 38, 38, 38, 38, 38, 
	38, 38, 1, 43, 43, 43, 43, 43, 
	43, 43, 43, 43, 1, 43, 43, 44, 
	43, 43, 43, 43, 43, 43, 43, 43, 
	43, 43, 43, 43, 43, 43, 43, 43, 
	43, 43, 43, 43, 43, 43, 43, 43, 
	43, 43, 45, 46, 43, 43, 43, 43, 
	43, 43, 43, 43, 43, 43, 43, 43, 
	43, 43, 43, 43, 43, 43, 43, 43, 
	43, 43, 43, 43, 43, 43, 43, 43, 
	43, 43, 43, 43, 43, 43, 43, 43, 
	43, 43, 43, 43, 43, 43, 43, 43, 
	43, 43, 43, 43, 43, 43, 47, 43, 
	43, 43, 43, 43, 43, 43, 43, 43, 
	43, 43, 43, 43, 43, 43, 43, 43, 
	43, 43, 43, 43, 43, 43, 43, 43, 
	43, 43, 43, 43, 43, 43, 43, 43, 
	43, 43, 1, 48, 1, 43, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 43, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 43, 49, 
	1, 1, 1, 50, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 49, 51, 
	51, 51, 51, 51, 51, 51, 52, 1, 
	51, 51, 51, 51, 51, 1, 51, 51, 
	51, 51, 51, 51, 51, 51, 51, 51, 
	1, 53, 1, 1, 1, 1, 1, 51, 
	51, 51, 51, 51, 51, 51, 51, 51, 
	51, 51, 51, 51, 51, 51, 51, 51, 
	51, 51, 51, 51, 51, 51, 51, 51, 
	51, 1, 1, 1, 51, 51, 51, 51, 
	51, 51, 51, 51, 51, 51, 51, 51, 
	51, 51, 51, 51, 51, 51, 51, 51, 
	51, 51, 51, 51, 51, 51, 51, 51, 
	51, 51, 51, 51, 51, 1, 54, 1, 
	1, 1, 55, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 54, 56, 1, 
	56, 56, 56, 56, 56, 57, 1, 56, 
	56, 56, 56, 56, 1, 56, 56, 56, 
	56, 56, 56, 56, 56, 56, 56, 1, 
	58, 1, 56, 1, 1, 1, 56, 56, 
	56, 56, 56, 56, 56, 56, 56, 56, 
	56, 56, 56, 56, 56, 56, 56, 56, 
	56, 56, 56, 56, 56, 56, 56, 56, 
	1, 1, 1, 56, 56, 56, 56, 56, 
	56, 56, 56, 56, 56, 56, 56, 56, 
	56, 56, 56, 56, 56, 56, 56, 56, 
	56, 56, 56, 56, 56, 56, 56, 56, 
	56, 56, 56, 56, 1, 16, 1, 1, 
	1, 59, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 16, 7, 7, 7, 
	7, 7, 7, 7, 60, 1, 7, 7, 
	7, 7, 7, 1, 7, 7, 7, 7, 
	7, 7, 7, 7, 7, 7, 1, 9, 
	1, 1, 1, 1, 1, 7, 7, 7, 
	7, 7, 7, 7, 7, 7, 7, 7, 
	7, 7, 7, 7, 7, 7, 7, 7, 
	7, 7, 7, 7, 7, 7, 7, 1, 
	1, 1, 7, 7, 7, 7, 7, 7, 
	7, 7, 7, 7, 7, 7, 7, 7, 
	7, 7, 7, 7, 7, 7, 7, 7, 
	7, 7, 7, 7, 7, 7, 7, 7, 
	7, 7, 7, 1, 61, 1, 1, 1, 
	62, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 61, 23, 23, 23, 23, 
	23, 23, 23, 63, 1, 23, 23, 23, 
	23, 23, 1, 23, 23, 23, 23, 23, 
	23, 23, 23, 23, 23, 1, 37, 1, 
	1, 1, 1, 1, 23, 23, 23, 23, 
	23, 23, 23, 23, 23, 23, 23, 23, 
	23, 23, 23, 23, 23, 23, 23, 23, 
	23, 23, 23, 23, 23, 23, 1, 1, 
	1, 23, 23, 23, 23, 23, 23, 23, 
	23, 23, 23, 23, 23, 23, 23, 23, 
	23, 23, 23, 23, 23, 23, 23, 23, 
	23, 23, 23, 23, 23, 23, 23, 23, 
	23, 23, 1, 54, 1, 1, 1, 55, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 54, 1, 1, 1, 1, 1, 
	1, 1, 57, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 58, 1, 1, 
	0
]

class << self
	attr_accessor :_content_type_trans_targs
	private :_content_type_trans_targs, :_content_type_trans_targs=
end
self._content_type_trans_targs = [
	2, 0, 2, 3, 27, 4, 5, 7, 
	21, 11, 6, 7, 8, 28, 16, 10, 
	29, 12, 13, 15, 14, 12, 13, 7, 
	15, 17, 18, 31, 20, 17, 18, 31, 
	20, 19, 4, 5, 21, 11, 23, 24, 
	23, 32, 26, 23, 24, 23, 32, 26, 
	25, 4, 5, 27, 21, 11, 29, 9, 
	28, 30, 11, 9, 30, 29, 9, 30
]

class << self
	attr_accessor :_content_type_trans_actions
	private :_content_type_trans_actions, :_content_type_trans_actions=
end
self._content_type_trans_actions = [
	1, 0, 0, 2, 3, 0, 0, 4, 
	5, 0, 0, 0, 6, 7, 7, 0, 
	0, 0, 0, 5, 0, 8, 8, 9, 
	10, 11, 11, 12, 11, 0, 0, 13, 
	0, 0, 8, 8, 10, 8, 14, 14, 
	15, 16, 14, 0, 0, 5, 17, 0, 
	0, 18, 18, 0, 19, 18, 20, 20, 
	0, 21, 20, 0, 5, 8, 8, 10
]

class << self
	attr_accessor :_content_type_eof_actions
	private :_content_type_eof_actions, :_content_type_eof_actions=
end
self._content_type_eof_actions = [
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 18, 20, 0, 8, 20, 
	0
]

class << self
	attr_accessor :content_type_start
end
self.content_type_start = 1;
class << self
	attr_accessor :content_type_first_final
end
self.content_type_first_final = 27;
class << self
	attr_accessor :content_type_error
end
self.content_type_error = 0;

class << self
	attr_accessor :content_type_en_comment_tail
end
self.content_type_en_comment_tail = 22;
class << self
	attr_accessor :content_type_en_main
end
self.content_type_en_main = 1;


# line 17 "/0/ruby/mail/lib/mail/parsers/ragel/ruby/machines/content_type_machine.rb.rl"

        def self.parse(data)
          p = 0
          eof = data.length
          stack = []

          actions = []
          data_unpacked = data.bytes.to_a
          
# line 454 "/0/ruby/mail/lib/mail/parsers/ragel/ruby/machines/content_type_machine.rb"
begin
	p ||= 0
	pe ||= data.length
	cs = content_type_start
	top = 0
end

# line 26 "/0/ruby/mail/lib/mail/parsers/ragel/ruby/machines/content_type_machine.rb.rl"
          
# line 464 "/0/ruby/mail/lib/mail/parsers/ragel/ruby/machines/content_type_machine.rb"
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
	_inds = _content_type_index_offsets[cs]
	_slen = _content_type_key_spans[cs]
	_trans = if (   _slen > 0 && 
			_content_type_trans_keys[_keys] <= ( data_unpacked[p]) && 
			( data_unpacked[p]) <= _content_type_trans_keys[_keys + 1] 
		    ) then
			_content_type_indicies[ _inds + ( data_unpacked[p]) - _content_type_trans_keys[_keys] ] 
		 else 
			_content_type_indicies[ _inds + _slen ]
		 end
	cs = _content_type_trans_targs[_trans]
	if _content_type_trans_actions[_trans] != 0
	case _content_type_trans_actions[_trans]
	when 8 then
# line 7 "/0/ruby/mail/lib/mail/parsers/ragel/ruby/machines/rb_actions.rl"
		begin
 actions.push(4, p) 		end
	when 14 then
# line 8 "/0/ruby/mail/lib/mail/parsers/ragel/ruby/machines/rb_actions.rl"
		begin
 actions.push(5, p) 		end
	when 2 then
# line 25 "/0/ruby/mail/lib/mail/parsers/ragel/ruby/machines/rb_actions.rl"
		begin
 actions.push(22, p) 		end
	when 1 then
# line 26 "/0/ruby/mail/lib/mail/parsers/ragel/ruby/machines/rb_actions.rl"
		begin
 actions.push(23, p) 		end
	when 6 then
# line 35 "/0/ruby/mail/lib/mail/parsers/ragel/ruby/machines/rb_actions.rl"
		begin
 actions.push(32, p) 		end
	when 4 then
# line 36 "/0/ruby/mail/lib/mail/parsers/ragel/ruby/machines/rb_actions.rl"
		begin
 actions.push(33, p) 		end
	when 20 then
# line 37 "/0/ruby/mail/lib/mail/parsers/ragel/ruby/machines/rb_actions.rl"
		begin
 actions.push(34, p) 		end
	when 7 then
# line 38 "/0/ruby/mail/lib/mail/parsers/ragel/ruby/machines/rb_actions.rl"
		begin
 actions.push(35, p) 		end
	when 13 then
# line 41 "/0/ruby/mail/lib/mail/parsers/ragel/ruby/machines/rb_actions.rl"
		begin
 actions.push(38, p) 		end
	when 11 then
# line 42 "/0/ruby/mail/lib/mail/parsers/ragel/ruby/machines/rb_actions.rl"
		begin
 actions.push(39, p) 		end
	when 18 then
# line 45 "/0/ruby/mail/lib/mail/parsers/ragel/ruby/machines/rb_actions.rl"
		begin
 actions.push(42, p) 		end
	when 3 then
# line 46 "/0/ruby/mail/lib/mail/parsers/ragel/ruby/machines/rb_actions.rl"
		begin
 actions.push(43, p) 		end
	when 5 then
# line 5 "/0/ruby/mail/lib/mail/parsers/ragel/ruby/machines/../../common.rl"
		begin
 	begin
		stack[top] = cs
		top+= 1
		cs = 22
		_goto_level = _again
		next
	end
 		end
	when 17 then
# line 6 "/0/ruby/mail/lib/mail/parsers/ragel/ruby/machines/../../common.rl"
		begin
 	begin
		top -= 1
		cs = stack[top]
		_goto_level = _again
		next
	end
 		end
	when 9 then
# line 7 "/0/ruby/mail/lib/mail/parsers/ragel/ruby/machines/rb_actions.rl"
		begin
 actions.push(4, p) 		end
# line 36 "/0/ruby/mail/lib/mail/parsers/ragel/ruby/machines/rb_actions.rl"
		begin
 actions.push(33, p) 		end
	when 10 then
# line 7 "/0/ruby/mail/lib/mail/parsers/ragel/ruby/machines/rb_actions.rl"
		begin
 actions.push(4, p) 		end
# line 5 "/0/ruby/mail/lib/mail/parsers/ragel/ruby/machines/../../common.rl"
		begin
 	begin
		stack[top] = cs
		top+= 1
		cs = 22
		_goto_level = _again
		next
	end
 		end
	when 15 then
# line 8 "/0/ruby/mail/lib/mail/parsers/ragel/ruby/machines/rb_actions.rl"
		begin
 actions.push(5, p) 		end
# line 5 "/0/ruby/mail/lib/mail/parsers/ragel/ruby/machines/../../common.rl"
		begin
 	begin
		stack[top] = cs
		top+= 1
		cs = 22
		_goto_level = _again
		next
	end
 		end
	when 16 then
# line 8 "/0/ruby/mail/lib/mail/parsers/ragel/ruby/machines/rb_actions.rl"
		begin
 actions.push(5, p) 		end
# line 6 "/0/ruby/mail/lib/mail/parsers/ragel/ruby/machines/../../common.rl"
		begin
 	begin
		top -= 1
		cs = stack[top]
		_goto_level = _again
		next
	end
 		end
	when 21 then
# line 37 "/0/ruby/mail/lib/mail/parsers/ragel/ruby/machines/rb_actions.rl"
		begin
 actions.push(34, p) 		end
# line 5 "/0/ruby/mail/lib/mail/parsers/ragel/ruby/machines/../../common.rl"
		begin
 	begin
		stack[top] = cs
		top+= 1
		cs = 22
		_goto_level = _again
		next
	end
 		end
	when 12 then
# line 42 "/0/ruby/mail/lib/mail/parsers/ragel/ruby/machines/rb_actions.rl"
		begin
 actions.push(39, p) 		end
# line 41 "/0/ruby/mail/lib/mail/parsers/ragel/ruby/machines/rb_actions.rl"
		begin
 actions.push(38, p) 		end
	when 19 then
# line 45 "/0/ruby/mail/lib/mail/parsers/ragel/ruby/machines/rb_actions.rl"
		begin
 actions.push(42, p) 		end
# line 5 "/0/ruby/mail/lib/mail/parsers/ragel/ruby/machines/../../common.rl"
		begin
 	begin
		stack[top] = cs
		top+= 1
		cs = 22
		_goto_level = _again
		next
	end
 		end
# line 652 "/0/ruby/mail/lib/mail/parsers/ragel/ruby/machines/content_type_machine.rb"
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
	  case _content_type_eof_actions[cs]
	when 8 then
# line 7 "/0/ruby/mail/lib/mail/parsers/ragel/ruby/machines/rb_actions.rl"
		begin
 actions.push(4, p) 		end
	when 20 then
# line 37 "/0/ruby/mail/lib/mail/parsers/ragel/ruby/machines/rb_actions.rl"
		begin
 actions.push(34, p) 		end
	when 18 then
# line 45 "/0/ruby/mail/lib/mail/parsers/ragel/ruby/machines/rb_actions.rl"
		begin
 actions.push(42, p) 		end
# line 682 "/0/ruby/mail/lib/mail/parsers/ragel/ruby/machines/content_type_machine.rb"
	  end
	end

	end
	if _goto_level <= _out
		break
	end
end
	end

# line 27 "/0/ruby/mail/lib/mail/parsers/ragel/ruby/machines/content_type_machine.rb.rl"

          if p == eof && cs >= 
# line 696 "/0/ruby/mail/lib/mail/parsers/ragel/ruby/machines/content_type_machine.rb"
27
# line 28 "/0/ruby/mail/lib/mail/parsers/ragel/ruby/machines/content_type_machine.rb.rl"

            return actions, nil
          else
            return [], "Only able to parse up to #{data[0..p]}"
          end
        end
      end
    end
  end
end
