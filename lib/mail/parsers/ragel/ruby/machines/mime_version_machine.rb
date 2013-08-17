
# line 1 "/Users/peter/src/mail/lib/mail/parsers/ragel/ruby/machines/mime_version_machine.rb.rl"

# line 10 "/Users/peter/src/mail/lib/mail/parsers/ragel/ruby/machines/mime_version_machine.rb.rl"


module Mail
  module Parsers
    module Ragel
      module MimeVersionMachine
        
# line 13 "/Users/peter/src/mail/lib/mail/parsers/ragel/ruby/machines/mime_version_machine.rb"
class << self
	attr_accessor :_mime_version_trans_keys
	private :_mime_version_trans_keys, :_mime_version_trans_keys=
end
self._mime_version_trans_keys = [
	0, 0, 9, 57, 10, 10, 
	9, 32, 9, 57, 40, 
	57, 46, 46, 40, 57, 
	48, 57, 10, 10, 9, 32, 
	-128, 92, -128, -65, -128, 
	92, -96, -65, -128, -65, 
	-128, -97, -112, -65, -128, -65, 
	-128, -113, 10, 10, 9, 
	32, -128, -12, -64, 92, 
	-128, 92, -128, 92, -128, 92, 
	-128, 92, -128, 92, -128, 
	92, 9, 57, 9, 40, 
	9, 40, 0, 0, 0
]

class << self
	attr_accessor :_mime_version_key_spans
	private :_mime_version_key_spans, :_mime_version_key_spans=
end
self._mime_version_key_spans = [
	0, 49, 1, 24, 49, 18, 1, 18, 
	10, 1, 24, 221, 64, 221, 32, 64, 
	32, 48, 64, 16, 1, 24, 117, 157, 
	221, 221, 221, 221, 221, 221, 49, 32, 
	32, 0
]

class << self
	attr_accessor :_mime_version_index_offsets
	private :_mime_version_index_offsets, :_mime_version_index_offsets=
end
self._mime_version_index_offsets = [
	0, 0, 50, 52, 77, 127, 146, 148, 
	167, 178, 180, 205, 427, 492, 714, 747, 
	812, 845, 894, 959, 976, 978, 1003, 1121, 
	1279, 1501, 1723, 1945, 2167, 2389, 2611, 2661, 
	2694, 2727
]

class << self
	attr_accessor :_mime_version_indicies
	private :_mime_version_indicies, :_mime_version_indicies=
end
self._mime_version_indicies = [
	0, 1, 1, 1, 2, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 0, 
	1, 1, 1, 1, 1, 1, 1, 3, 
	1, 1, 1, 1, 1, 1, 1, 4, 
	4, 4, 4, 4, 4, 4, 4, 4, 
	4, 1, 5, 1, 0, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 0, 1, 6, 1, 1, 
	1, 7, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 6, 1, 1, 1, 
	1, 1, 1, 1, 8, 1, 1, 1, 
	1, 1, 1, 1, 9, 9, 9, 9, 
	9, 9, 9, 9, 9, 9, 1, 10, 
	1, 1, 1, 1, 1, 11, 1, 12, 
	12, 12, 12, 12, 12, 12, 12, 12, 
	12, 1, 13, 1, 14, 1, 1, 1, 
	1, 1, 1, 1, 15, 15, 15, 15, 
	15, 15, 15, 15, 15, 15, 1, 16, 
	16, 16, 16, 16, 16, 16, 16, 16, 
	16, 1, 17, 1, 18, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 18, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 19, 
	19, 19, 19, 19, 19, 19, 19, 19, 
	19, 19, 19, 19, 19, 19, 19, 19, 
	19, 19, 19, 19, 19, 19, 19, 19, 
	19, 19, 19, 19, 19, 20, 21, 21, 
	21, 21, 21, 21, 21, 21, 21, 21, 
	21, 21, 22, 21, 21, 23, 24, 24, 
	24, 25, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 26, 26, 
	26, 26, 26, 26, 26, 26, 26, 1, 
	26, 26, 27, 26, 26, 26, 26, 26, 
	26, 26, 26, 26, 26, 26, 26, 26, 
	26, 26, 26, 26, 26, 26, 26, 26, 
	26, 26, 26, 26, 26, 28, 29, 26, 
	26, 26, 26, 26, 26, 26, 26, 26, 
	26, 26, 26, 26, 26, 26, 26, 26, 
	26, 26, 26, 26, 26, 26, 26, 26, 
	26, 26, 26, 26, 26, 26, 26, 26, 
	26, 26, 26, 26, 26, 26, 26, 26, 
	26, 26, 26, 26, 26, 26, 26, 26, 
	26, 30, 26, 31, 31, 31, 31, 31, 
	31, 31, 31, 31, 31, 31, 31, 31, 
	31, 31, 31, 31, 31, 31, 31, 31, 
	31, 31, 31, 31, 31, 31, 31, 31, 
	31, 31, 31, 31, 31, 31, 31, 31, 
	31, 31, 31, 31, 31, 31, 31, 31, 
	31, 31, 31, 31, 31, 31, 31, 31, 
	31, 31, 31, 31, 31, 31, 31, 31, 
	31, 31, 31, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 32, 32, 
	32, 32, 32, 32, 32, 32, 32, 32, 
	32, 32, 32, 32, 32, 32, 32, 32, 
	32, 32, 32, 32, 32, 32, 32, 32, 
	32, 32, 32, 32, 33, 34, 34, 34, 
	34, 34, 34, 34, 34, 34, 34, 34, 
	34, 35, 34, 34, 36, 37, 37, 37, 
	38, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 31, 31, 31, 
	31, 31, 31, 31, 31, 31, 1, 31, 
	31, 39, 31, 31, 31, 31, 31, 31, 
	31, 31, 31, 31, 31, 31, 31, 31, 
	31, 31, 31, 31, 31, 31, 31, 31, 
	31, 31, 31, 31, 40, 41, 31, 31, 
	31, 31, 31, 31, 31, 31, 31, 31, 
	31, 31, 31, 31, 31, 31, 31, 31, 
	31, 31, 31, 31, 31, 31, 31, 31, 
	31, 31, 31, 31, 31, 31, 31, 31, 
	31, 31, 31, 31, 31, 31, 31, 31, 
	31, 31, 31, 31, 31, 31, 31, 31, 
	42, 31, 32, 32, 32, 32, 32, 32, 
	32, 32, 32, 32, 32, 32, 32, 32, 
	32, 32, 32, 32, 32, 32, 32, 32, 
	32, 32, 32, 32, 32, 32, 32, 32, 
	32, 32, 1, 32, 32, 32, 32, 32, 
	32, 32, 32, 32, 32, 32, 32, 32, 
	32, 32, 32, 32, 32, 32, 32, 32, 
	32, 32, 32, 32, 32, 32, 32, 32, 
	32, 32, 32, 32, 32, 32, 32, 32, 
	32, 32, 32, 32, 32, 32, 32, 32, 
	32, 32, 32, 32, 32, 32, 32, 32, 
	32, 32, 32, 32, 32, 32, 32, 32, 
	32, 32, 32, 1, 32, 32, 32, 32, 
	32, 32, 32, 32, 32, 32, 32, 32, 
	32, 32, 32, 32, 32, 32, 32, 32, 
	32, 32, 32, 32, 32, 32, 32, 32, 
	32, 32, 32, 32, 1, 34, 34, 34, 
	34, 34, 34, 34, 34, 34, 34, 34, 
	34, 34, 34, 34, 34, 34, 34, 34, 
	34, 34, 34, 34, 34, 34, 34, 34, 
	34, 34, 34, 34, 34, 34, 34, 34, 
	34, 34, 34, 34, 34, 34, 34, 34, 
	34, 34, 34, 34, 34, 1, 34, 34, 
	34, 34, 34, 34, 34, 34, 34, 34, 
	34, 34, 34, 34, 34, 34, 34, 34, 
	34, 34, 34, 34, 34, 34, 34, 34, 
	34, 34, 34, 34, 34, 34, 34, 34, 
	34, 34, 34, 34, 34, 34, 34, 34, 
	34, 34, 34, 34, 34, 34, 34, 34, 
	34, 34, 34, 34, 34, 34, 34, 34, 
	34, 34, 34, 34, 34, 34, 1, 34, 
	34, 34, 34, 34, 34, 34, 34, 34, 
	34, 34, 34, 34, 34, 34, 34, 1, 
	43, 1, 31, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 31, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 31, 31, 31, 31, 31, 
	31, 31, 31, 31, 31, 31, 31, 31, 
	31, 31, 31, 31, 31, 31, 31, 31, 
	31, 31, 31, 31, 31, 31, 31, 31, 
	31, 31, 31, 31, 31, 44, 44, 44, 
	44, 44, 44, 44, 44, 44, 44, 44, 
	44, 44, 44, 44, 44, 44, 44, 44, 
	44, 44, 44, 44, 44, 44, 44, 44, 
	44, 44, 44, 45, 46, 46, 46, 46, 
	46, 46, 46, 46, 46, 46, 46, 46, 
	47, 46, 46, 48, 49, 49, 49, 50, 
	31, 1, 1, 32, 32, 32, 32, 32, 
	32, 32, 32, 32, 32, 32, 32, 32, 
	32, 32, 32, 32, 32, 32, 32, 32, 
	32, 32, 32, 32, 32, 32, 32, 32, 
	32, 33, 34, 34, 34, 34, 34, 34, 
	34, 34, 34, 34, 34, 34, 35, 34, 
	34, 36, 37, 37, 37, 38, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 31, 31, 31, 31, 31, 31, 
	31, 31, 31, 1, 31, 31, 39, 31, 
	31, 31, 31, 31, 31, 31, 31, 31, 
	31, 31, 31, 31, 31, 31, 31, 31, 
	31, 31, 31, 31, 31, 31, 31, 31, 
	31, 40, 41, 31, 31, 31, 31, 31, 
	31, 31, 31, 31, 31, 31, 31, 31, 
	31, 31, 31, 31, 31, 31, 31, 31, 
	31, 31, 31, 31, 31, 31, 31, 31, 
	31, 31, 31, 31, 31, 31, 31, 31, 
	31, 31, 31, 31, 31, 31, 31, 31, 
	31, 31, 31, 31, 31, 42, 31, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 32, 
	32, 32, 32, 32, 32, 32, 32, 32, 
	32, 32, 32, 32, 32, 32, 32, 32, 
	32, 32, 32, 32, 32, 32, 32, 32, 
	32, 32, 32, 32, 32, 32, 32, 1, 
	1, 32, 32, 32, 32, 32, 32, 32, 
	32, 32, 32, 32, 32, 32, 32, 32, 
	32, 32, 32, 32, 32, 32, 32, 32, 
	32, 32, 32, 32, 32, 32, 32, 33, 
	34, 34, 34, 34, 34, 34, 34, 34, 
	34, 34, 34, 34, 35, 34, 34, 36, 
	37, 37, 37, 38, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	31, 31, 31, 31, 31, 31, 31, 31, 
	31, 1, 31, 31, 39, 31, 31, 31, 
	31, 31, 31, 31, 31, 31, 31, 31, 
	31, 31, 31, 31, 31, 31, 31, 31, 
	31, 31, 31, 31, 31, 31, 31, 40, 
	41, 31, 31, 31, 31, 31, 31, 31, 
	31, 31, 31, 31, 31, 31, 31, 31, 
	31, 31, 31, 31, 31, 31, 31, 31, 
	31, 31, 31, 31, 31, 31, 31, 31, 
	31, 31, 31, 31, 31, 31, 31, 31, 
	31, 31, 31, 31, 31, 31, 31, 31, 
	31, 31, 31, 42, 31, 32, 32, 32, 
	32, 32, 32, 32, 32, 32, 32, 32, 
	32, 32, 32, 32, 32, 32, 32, 32, 
	32, 32, 32, 32, 32, 32, 32, 32, 
	32, 32, 32, 32, 32, 32, 32, 32, 
	32, 32, 32, 32, 32, 32, 32, 32, 
	32, 32, 32, 32, 32, 32, 32, 32, 
	32, 32, 32, 32, 32, 32, 32, 32, 
	32, 32, 32, 32, 32, 1, 1, 32, 
	32, 32, 32, 32, 32, 32, 32, 32, 
	32, 32, 32, 32, 32, 32, 32, 32, 
	32, 32, 32, 32, 32, 32, 32, 32, 
	32, 32, 32, 32, 32, 33, 34, 34, 
	34, 34, 34, 34, 34, 34, 34, 34, 
	34, 34, 35, 34, 34, 36, 37, 37, 
	37, 38, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 31, 31, 
	31, 31, 31, 31, 31, 31, 31, 1, 
	31, 31, 39, 31, 31, 31, 31, 31, 
	31, 31, 31, 31, 31, 31, 31, 31, 
	31, 31, 31, 31, 31, 31, 31, 31, 
	31, 31, 31, 31, 31, 40, 41, 31, 
	31, 31, 31, 31, 31, 31, 31, 31, 
	31, 31, 31, 31, 31, 31, 31, 31, 
	31, 31, 31, 31, 31, 31, 31, 31, 
	31, 31, 31, 31, 31, 31, 31, 31, 
	31, 31, 31, 31, 31, 31, 31, 31, 
	31, 31, 31, 31, 31, 31, 31, 31, 
	31, 42, 31, 32, 32, 32, 32, 32, 
	32, 32, 32, 32, 32, 32, 32, 32, 
	32, 32, 32, 32, 32, 32, 32, 32, 
	32, 32, 32, 32, 32, 32, 32, 32, 
	32, 32, 32, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 32, 32, 32, 
	32, 32, 32, 32, 32, 32, 32, 32, 
	32, 32, 32, 32, 32, 32, 32, 32, 
	32, 32, 32, 32, 32, 32, 32, 32, 
	32, 32, 32, 33, 34, 34, 34, 34, 
	34, 34, 34, 34, 34, 34, 34, 34, 
	35, 34, 34, 36, 37, 37, 37, 38, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 31, 31, 31, 31, 
	31, 31, 31, 31, 31, 1, 31, 31, 
	39, 31, 31, 31, 31, 31, 31, 31, 
	31, 31, 31, 31, 31, 31, 31, 31, 
	31, 31, 31, 31, 31, 31, 31, 31, 
	31, 31, 31, 40, 41, 31, 31, 31, 
	31, 31, 31, 31, 31, 31, 31, 31, 
	31, 31, 31, 31, 31, 31, 31, 31, 
	31, 31, 31, 31, 31, 31, 31, 31, 
	31, 31, 31, 31, 31, 31, 31, 31, 
	31, 31, 31, 31, 31, 31, 31, 31, 
	31, 31, 31, 31, 31, 31, 31, 42, 
	31, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 34, 34, 34, 34, 34, 34, 34, 
	34, 34, 34, 34, 34, 34, 34, 34, 
	34, 34, 34, 34, 34, 34, 34, 34, 
	34, 34, 34, 34, 34, 34, 34, 34, 
	34, 34, 34, 34, 34, 34, 34, 34, 
	34, 34, 34, 34, 34, 34, 34, 34, 
	34, 1, 1, 32, 32, 32, 32, 32, 
	32, 32, 32, 32, 32, 32, 32, 32, 
	32, 32, 32, 32, 32, 32, 32, 32, 
	32, 32, 32, 32, 32, 32, 32, 32, 
	32, 33, 34, 34, 34, 34, 34, 34, 
	34, 34, 34, 34, 34, 34, 35, 34, 
	34, 36, 37, 37, 37, 38, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 31, 31, 31, 31, 31, 31, 
	31, 31, 31, 1, 31, 31, 39, 31, 
	31, 31, 31, 31, 31, 31, 31, 31, 
	31, 31, 31, 31, 31, 31, 31, 31, 
	31, 31, 31, 31, 31, 31, 31, 31, 
	31, 40, 41, 31, 31, 31, 31, 31, 
	31, 31, 31, 31, 31, 31, 31, 31, 
	31, 31, 31, 31, 31, 31, 31, 31, 
	31, 31, 31, 31, 31, 31, 31, 31, 
	31, 31, 31, 31, 31, 31, 31, 31, 
	31, 31, 31, 31, 31, 31, 31, 31, 
	31, 31, 31, 31, 31, 42, 31, 34, 
	34, 34, 34, 34, 34, 34, 34, 34, 
	34, 34, 34, 34, 34, 34, 34, 34, 
	34, 34, 34, 34, 34, 34, 34, 34, 
	34, 34, 34, 34, 34, 34, 34, 34, 
	34, 34, 34, 34, 34, 34, 34, 34, 
	34, 34, 34, 34, 34, 34, 34, 34, 
	34, 34, 34, 34, 34, 34, 34, 34, 
	34, 34, 34, 34, 34, 34, 34, 1, 
	1, 32, 32, 32, 32, 32, 32, 32, 
	32, 32, 32, 32, 32, 32, 32, 32, 
	32, 32, 32, 32, 32, 32, 32, 32, 
	32, 32, 32, 32, 32, 32, 32, 33, 
	34, 34, 34, 34, 34, 34, 34, 34, 
	34, 34, 34, 34, 35, 34, 34, 36, 
	37, 37, 37, 38, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	31, 31, 31, 31, 31, 31, 31, 31, 
	31, 1, 31, 31, 39, 31, 31, 31, 
	31, 31, 31, 31, 31, 31, 31, 31, 
	31, 31, 31, 31, 31, 31, 31, 31, 
	31, 31, 31, 31, 31, 31, 31, 40, 
	41, 31, 31, 31, 31, 31, 31, 31, 
	31, 31, 31, 31, 31, 31, 31, 31, 
	31, 31, 31, 31, 31, 31, 31, 31, 
	31, 31, 31, 31, 31, 31, 31, 31, 
	31, 31, 31, 31, 31, 31, 31, 31, 
	31, 31, 31, 31, 31, 31, 31, 31, 
	31, 31, 31, 42, 31, 34, 34, 34, 
	34, 34, 34, 34, 34, 34, 34, 34, 
	34, 34, 34, 34, 34, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 32, 
	32, 32, 32, 32, 32, 32, 32, 32, 
	32, 32, 32, 32, 32, 32, 32, 32, 
	32, 32, 32, 32, 32, 32, 32, 32, 
	32, 32, 32, 32, 32, 33, 34, 34, 
	34, 34, 34, 34, 34, 34, 34, 34, 
	34, 34, 35, 34, 34, 36, 37, 37, 
	37, 38, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 31, 31, 
	31, 31, 31, 31, 31, 31, 31, 1, 
	31, 31, 39, 31, 31, 31, 31, 31, 
	31, 31, 31, 31, 31, 31, 31, 31, 
	31, 31, 31, 31, 31, 31, 31, 31, 
	31, 31, 31, 31, 31, 40, 41, 31, 
	31, 31, 31, 31, 31, 31, 31, 31, 
	31, 31, 31, 31, 31, 31, 31, 31, 
	31, 31, 31, 31, 31, 31, 31, 31, 
	31, 31, 31, 31, 31, 31, 31, 31, 
	31, 31, 31, 31, 31, 31, 31, 31, 
	31, 31, 31, 31, 31, 31, 31, 31, 
	31, 42, 31, 51, 1, 1, 1, 52, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 51, 1, 1, 1, 1, 1, 
	1, 1, 53, 1, 1, 1, 1, 1, 
	1, 1, 54, 54, 54, 54, 54, 54, 
	54, 54, 54, 54, 1, 18, 1, 1, 
	1, 55, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 18, 1, 1, 1, 
	1, 1, 1, 1, 56, 1, 57, 1, 
	1, 1, 58, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 57, 1, 1, 
	1, 1, 1, 1, 1, 59, 1, 1, 
	0
]

class << self
	attr_accessor :_mime_version_trans_targs
	private :_mime_version_trans_targs, :_mime_version_trans_targs=
end
self._mime_version_trans_targs = [
	1, 0, 2, 4, 5, 3, 1, 2, 
	4, 5, 6, 7, 5, 7, 8, 30, 
	30, 10, 31, 12, 14, 15, 16, 17, 
	18, 19, 13, 20, 13, 33, 22, 13, 
	12, 14, 15, 16, 17, 18, 19, 20, 
	13, 33, 22, 21, 23, 24, 25, 26, 
	27, 28, 29, 31, 9, 32, 30, 9, 
	32, 31, 9, 32
]

class << self
	attr_accessor :_mime_version_trans_actions
	private :_mime_version_trans_actions, :_mime_version_trans_actions=
end
self._mime_version_trans_actions = [
	0, 0, 0, 1, 2, 0, 3, 3, 
	4, 5, 6, 7, 0, 3, 1, 8, 
	9, 0, 0, 10, 10, 10, 10, 10, 
	10, 10, 10, 10, 11, 12, 10, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	1, 13, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 14, 14, 15, 0, 0, 
	1, 3, 3, 4
]

class << self
	attr_accessor :_mime_version_eof_actions
	private :_mime_version_eof_actions, :_mime_version_eof_actions=
end
self._mime_version_eof_actions = [
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 14, 0, 
	3, 0
]

class << self
	attr_accessor :mime_version_start
end
self.mime_version_start = 1;
class << self
	attr_accessor :mime_version_first_final
end
self.mime_version_first_final = 30;
class << self
	attr_accessor :mime_version_error
end
self.mime_version_error = 0;

class << self
	attr_accessor :mime_version_en_comment_tail
end
self.mime_version_en_comment_tail = 11;
class << self
	attr_accessor :mime_version_en_main
end
self.mime_version_en_main = 1;


# line 17 "/Users/peter/src/mail/lib/mail/parsers/ragel/ruby/machines/mime_version_machine.rb.rl"

        def self.parse(data)
          p = 0
          eof = data.length
          stack = []

          actions = []
          data_unpacked = data.bytes.to_a
          
# line 482 "/Users/peter/src/mail/lib/mail/parsers/ragel/ruby/machines/mime_version_machine.rb"
begin
	p ||= 0
	pe ||= data.length
	cs = mime_version_start
	top = 0
end

# line 26 "/Users/peter/src/mail/lib/mail/parsers/ragel/ruby/machines/mime_version_machine.rb.rl"
          
# line 492 "/Users/peter/src/mail/lib/mail/parsers/ragel/ruby/machines/mime_version_machine.rb"
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
	_inds = _mime_version_index_offsets[cs]
	_slen = _mime_version_key_spans[cs]
	_trans = if (   _slen > 0 && 
			_mime_version_trans_keys[_keys] <= ( data_unpacked[p]) && 
			( data_unpacked[p]) <= _mime_version_trans_keys[_keys + 1] 
		    ) then
			_mime_version_indicies[ _inds + ( data_unpacked[p]) - _mime_version_trans_keys[_keys] ] 
		 else 
			_mime_version_indicies[ _inds + _slen ]
		 end
	cs = _mime_version_trans_targs[_trans]
	if _mime_version_trans_actions[_trans] != 0
	case _mime_version_trans_actions[_trans]
	when 3 then
# line 7 "/Users/peter/src/mail/lib/mail/parsers/ragel/ruby/machines/rb_actions.rl"
		begin
 actions.push(4, p) 		end
	when 10 then
# line 8 "/Users/peter/src/mail/lib/mail/parsers/ragel/ruby/machines/rb_actions.rl"
		begin
 actions.push(5, p) 		end
	when 7 then
# line 27 "/Users/peter/src/mail/lib/mail/parsers/ragel/ruby/machines/rb_actions.rl"
		begin
 actions.push(24, p) 		end
	when 2 then
# line 28 "/Users/peter/src/mail/lib/mail/parsers/ragel/ruby/machines/rb_actions.rl"
		begin
 actions.push(25, p) 		end
	when 14 then
# line 29 "/Users/peter/src/mail/lib/mail/parsers/ragel/ruby/machines/rb_actions.rl"
		begin
 actions.push(26, p) 		end
	when 8 then
# line 30 "/Users/peter/src/mail/lib/mail/parsers/ragel/ruby/machines/rb_actions.rl"
		begin
 actions.push(27, p) 		end
	when 1 then
# line 5 "/Users/peter/src/mail/lib/mail/parsers/ragel/ruby/machines/../../common.rl"
		begin
 	begin
		stack[top] = cs
		top+= 1
		cs = 11
		_goto_level = _again
		next
	end
 		end
	when 13 then
# line 6 "/Users/peter/src/mail/lib/mail/parsers/ragel/ruby/machines/../../common.rl"
		begin
 	begin
		top -= 1
		cs = stack[top]
		_goto_level = _again
		next
	end
 		end
	when 5 then
# line 7 "/Users/peter/src/mail/lib/mail/parsers/ragel/ruby/machines/rb_actions.rl"
		begin
 actions.push(4, p) 		end
# line 28 "/Users/peter/src/mail/lib/mail/parsers/ragel/ruby/machines/rb_actions.rl"
		begin
 actions.push(25, p) 		end
	when 9 then
# line 7 "/Users/peter/src/mail/lib/mail/parsers/ragel/ruby/machines/rb_actions.rl"
		begin
 actions.push(4, p) 		end
# line 30 "/Users/peter/src/mail/lib/mail/parsers/ragel/ruby/machines/rb_actions.rl"
		begin
 actions.push(27, p) 		end
	when 4 then
# line 7 "/Users/peter/src/mail/lib/mail/parsers/ragel/ruby/machines/rb_actions.rl"
		begin
 actions.push(4, p) 		end
# line 5 "/Users/peter/src/mail/lib/mail/parsers/ragel/ruby/machines/../../common.rl"
		begin
 	begin
		stack[top] = cs
		top+= 1
		cs = 11
		_goto_level = _again
		next
	end
 		end
	when 11 then
# line 8 "/Users/peter/src/mail/lib/mail/parsers/ragel/ruby/machines/rb_actions.rl"
		begin
 actions.push(5, p) 		end
# line 5 "/Users/peter/src/mail/lib/mail/parsers/ragel/ruby/machines/../../common.rl"
		begin
 	begin
		stack[top] = cs
		top+= 1
		cs = 11
		_goto_level = _again
		next
	end
 		end
	when 12 then
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
	when 6 then
# line 27 "/Users/peter/src/mail/lib/mail/parsers/ragel/ruby/machines/rb_actions.rl"
		begin
 actions.push(24, p) 		end
# line 5 "/Users/peter/src/mail/lib/mail/parsers/ragel/ruby/machines/../../common.rl"
		begin
 	begin
		stack[top] = cs
		top+= 1
		cs = 11
		_goto_level = _again
		next
	end
 		end
	when 15 then
# line 29 "/Users/peter/src/mail/lib/mail/parsers/ragel/ruby/machines/rb_actions.rl"
		begin
 actions.push(26, p) 		end
# line 5 "/Users/peter/src/mail/lib/mail/parsers/ragel/ruby/machines/../../common.rl"
		begin
 	begin
		stack[top] = cs
		top+= 1
		cs = 11
		_goto_level = _again
		next
	end
 		end
# line 656 "/Users/peter/src/mail/lib/mail/parsers/ragel/ruby/machines/mime_version_machine.rb"
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
	  case _mime_version_eof_actions[cs]
	when 3 then
# line 7 "/Users/peter/src/mail/lib/mail/parsers/ragel/ruby/machines/rb_actions.rl"
		begin
 actions.push(4, p) 		end
	when 14 then
# line 29 "/Users/peter/src/mail/lib/mail/parsers/ragel/ruby/machines/rb_actions.rl"
		begin
 actions.push(26, p) 		end
# line 682 "/Users/peter/src/mail/lib/mail/parsers/ragel/ruby/machines/mime_version_machine.rb"
	  end
	end

	end
	if _goto_level <= _out
		break
	end
end
	end

# line 27 "/Users/peter/src/mail/lib/mail/parsers/ragel/ruby/machines/mime_version_machine.rb.rl"

          if p == eof && cs >= 
# line 696 "/Users/peter/src/mail/lib/mail/parsers/ragel/ruby/machines/mime_version_machine.rb"
30
# line 28 "/Users/peter/src/mail/lib/mail/parsers/ragel/ruby/machines/mime_version_machine.rb.rl"

            return actions, nil
          else
            return [], "Only able to parse up to #{data[0..p]}"
          end
        end
      end
    end
  end
end
