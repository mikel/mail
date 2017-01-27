
# frozen_string_literal: true
require 'mail/utilities'




module Mail::Parsers
  module ContentDispositionParser
    ContentDispositionStruct = Struct.new(:disposition_type, :parameters, :error)

    
class << self
	attr_accessor :_trans_keys
	private :_trans_keys, :_trans_keys=
end
self._trans_keys = [
	0, 0, 33, 126, 9, 126, 
	10, 10, 9, 32, 33, 
	126, 9, 126, 9, 40, 
	10, 10, 9, 32, 1, 127, 
	1, 127, 10, 10, 9, 
	32, 10, 10, 9, 32, 
	-128, -1, 9, 40, 10, 10, 
	9, 32, 9, 126, 1, 
	127, 1, 127, 10, 10, 
	9, 32, -128, -1, 33, 126, 
	9, 59, 9, 59, 9, 
	126, 9, 59, 9, 59, 
	0, 0, 0
]

class << self
	attr_accessor :_key_spans
	private :_key_spans, :_key_spans=
end
self._key_spans = [
	0, 94, 118, 1, 24, 94, 118, 32, 
	1, 24, 127, 127, 1, 24, 1, 24, 
	128, 32, 1, 24, 118, 127, 127, 1, 
	24, 128, 94, 51, 51, 118, 51, 51, 
	0
]

class << self
	attr_accessor :_index_offsets
	private :_index_offsets, :_index_offsets=
end
self._index_offsets = [
	0, 0, 95, 214, 216, 241, 336, 455, 
	488, 490, 515, 643, 771, 773, 798, 800, 
	825, 954, 987, 989, 1014, 1133, 1261, 1389, 
	1391, 1416, 1545, 1640, 1692, 1744, 1863, 1915, 
	1967
]

class << self
	attr_accessor :_indicies
	private :_indicies, :_indicies=
end
self._indicies = [
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
	1, 1, 1, 3, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 2, 4, 
	4, 4, 4, 4, 4, 4, 5, 1, 
	4, 4, 4, 4, 4, 1, 4, 4, 
	4, 4, 4, 4, 4, 4, 4, 4, 
	1, 1, 1, 1, 1, 1, 1, 4, 
	4, 4, 4, 4, 4, 4, 4, 4, 
	4, 4, 4, 4, 4, 4, 4, 4, 
	4, 4, 4, 4, 4, 4, 4, 4, 
	4, 1, 1, 1, 4, 4, 4, 4, 
	4, 4, 4, 4, 4, 4, 4, 4, 
	4, 4, 4, 4, 4, 4, 4, 4, 
	4, 4, 4, 4, 4, 4, 4, 4, 
	4, 4, 4, 4, 4, 1, 6, 1, 
	2, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 2, 
	1, 7, 7, 7, 7, 7, 7, 7, 
	1, 1, 7, 7, 7, 7, 7, 1, 
	7, 7, 7, 7, 7, 7, 7, 7, 
	7, 7, 1, 1, 1, 8, 1, 1, 
	1, 7, 7, 7, 7, 7, 7, 7, 
	7, 7, 7, 7, 7, 7, 7, 7, 
	7, 7, 7, 7, 7, 7, 7, 7, 
	7, 7, 7, 1, 1, 1, 7, 7, 
	7, 7, 7, 7, 7, 7, 7, 7, 
	7, 7, 7, 7, 7, 7, 7, 7, 
	7, 7, 7, 7, 7, 7, 7, 7, 
	7, 7, 7, 7, 7, 7, 7, 1, 
	9, 1, 1, 1, 10, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 9, 
	11, 12, 11, 11, 11, 11, 11, 13, 
	1, 11, 11, 11, 11, 11, 1, 11, 
	11, 11, 11, 11, 11, 11, 11, 11, 
	11, 1, 1, 1, 11, 1, 1, 1, 
	11, 11, 11, 11, 11, 11, 11, 11, 
	11, 11, 11, 11, 11, 11, 11, 11, 
	11, 11, 11, 11, 11, 11, 11, 11, 
	11, 11, 1, 1, 1, 11, 11, 11, 
	11, 11, 11, 11, 11, 11, 11, 11, 
	11, 11, 11, 11, 11, 11, 11, 11, 
	11, 11, 11, 11, 11, 11, 11, 11, 
	11, 11, 11, 11, 11, 11, 1, 14, 
	1, 1, 1, 15, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 14, 1, 
	16, 1, 1, 1, 1, 1, 17, 1, 
	18, 1, 14, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 14, 1, 19, 19, 19, 19, 19, 
	19, 19, 19, 19, 1, 19, 19, 20, 
	19, 19, 19, 19, 19, 19, 19, 19, 
	19, 19, 19, 19, 19, 19, 19, 19, 
	19, 19, 19, 19, 21, 19, 19, 19, 
	19, 19, 19, 19, 19, 19, 19, 19, 
	19, 19, 19, 19, 19, 19, 19, 19, 
	19, 19, 19, 19, 19, 19, 19, 19, 
	19, 19, 19, 19, 19, 19, 19, 19, 
	19, 19, 19, 19, 19, 19, 19, 19, 
	19, 19, 19, 19, 19, 19, 19, 19, 
	19, 19, 19, 19, 19, 19, 22, 19, 
	19, 19, 19, 19, 19, 19, 19, 19, 
	19, 19, 19, 19, 19, 19, 19, 19, 
	19, 19, 19, 19, 19, 19, 19, 19, 
	19, 19, 19, 19, 19, 19, 19, 19, 
	19, 19, 1, 23, 23, 23, 23, 23, 
	23, 23, 23, 23, 1, 23, 23, 24, 
	23, 23, 23, 23, 23, 23, 23, 23, 
	23, 23, 23, 23, 23, 23, 23, 23, 
	23, 23, 23, 23, 25, 23, 23, 23, 
	23, 23, 23, 23, 23, 23, 23, 23, 
	23, 23, 23, 23, 23, 23, 23, 23, 
	23, 23, 23, 23, 23, 23, 23, 23, 
	23, 23, 23, 23, 23, 23, 23, 23, 
	23, 23, 23, 23, 23, 23, 23, 23, 
	23, 23, 23, 23, 23, 23, 23, 23, 
	23, 23, 23, 23, 23, 23, 26, 23, 
	23, 23, 23, 23, 23, 23, 23, 23, 
	23, 23, 23, 23, 23, 23, 23, 23, 
	23, 23, 23, 23, 23, 23, 23, 23, 
	23, 23, 23, 23, 23, 23, 23, 23, 
	23, 23, 1, 27, 1, 23, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 23, 1, 28, 1, 
	29, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 29, 
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
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 23, 30, 1, 1, 1, 31, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 30, 1, 32, 1, 1, 1, 1, 
	1, 33, 1, 34, 1, 35, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 35, 1, 36, 1, 
	1, 1, 37, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 36, 38, 38, 
	38, 38, 38, 38, 38, 39, 1, 38, 
	38, 38, 38, 38, 1, 38, 38, 38, 
	38, 38, 38, 38, 38, 38, 38, 1, 
	1, 1, 1, 1, 1, 1, 38, 38, 
	38, 38, 38, 38, 38, 38, 38, 38, 
	38, 38, 38, 38, 38, 38, 38, 38, 
	38, 38, 38, 38, 38, 38, 38, 38, 
	1, 1, 1, 38, 38, 38, 38, 38, 
	38, 38, 38, 38, 38, 38, 38, 38, 
	38, 38, 38, 38, 38, 38, 38, 38, 
	38, 38, 38, 38, 38, 38, 38, 38, 
	38, 38, 38, 38, 1, 40, 40, 40, 
	40, 40, 40, 40, 40, 40, 1, 40, 
	40, 41, 40, 40, 40, 40, 40, 40, 
	40, 40, 40, 40, 40, 40, 40, 40, 
	40, 40, 40, 40, 40, 40, 40, 40, 
	40, 40, 40, 40, 42, 43, 40, 40, 
	40, 40, 40, 40, 40, 40, 40, 40, 
	40, 40, 40, 40, 40, 40, 40, 40, 
	40, 40, 40, 40, 40, 40, 40, 40, 
	40, 40, 40, 40, 40, 40, 40, 40, 
	40, 40, 40, 40, 40, 40, 40, 40, 
	40, 40, 40, 40, 40, 40, 40, 40, 
	44, 40, 40, 40, 40, 40, 40, 40, 
	40, 40, 40, 40, 40, 40, 40, 40, 
	40, 40, 40, 40, 40, 40, 40, 40, 
	40, 40, 40, 40, 40, 40, 40, 40, 
	40, 40, 40, 40, 1, 45, 45, 45, 
	45, 45, 45, 45, 45, 45, 1, 45, 
	45, 46, 45, 45, 45, 45, 45, 45, 
	45, 45, 45, 45, 45, 45, 45, 45, 
	45, 45, 45, 45, 45, 45, 45, 45, 
	45, 45, 45, 45, 47, 48, 45, 45, 
	45, 45, 45, 45, 45, 45, 45, 45, 
	45, 45, 45, 45, 45, 45, 45, 45, 
	45, 45, 45, 45, 45, 45, 45, 45, 
	45, 45, 45, 45, 45, 45, 45, 45, 
	45, 45, 45, 45, 45, 45, 45, 45, 
	45, 45, 45, 45, 45, 45, 45, 45, 
	49, 45, 45, 45, 45, 45, 45, 45, 
	45, 45, 45, 45, 45, 45, 45, 45, 
	45, 45, 45, 45, 45, 45, 45, 45, 
	45, 45, 45, 45, 45, 45, 45, 45, 
	45, 45, 45, 45, 1, 50, 1, 45, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 45, 1, 
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
	1, 1, 1, 1, 1, 1, 1, 1, 
	45, 51, 51, 51, 51, 51, 51, 51, 
	1, 1, 51, 51, 51, 51, 51, 1, 
	51, 51, 51, 51, 51, 51, 51, 51, 
	51, 51, 1, 52, 1, 1, 1, 1, 
	1, 51, 51, 51, 51, 51, 51, 51, 
	51, 51, 51, 51, 51, 51, 51, 51, 
	51, 51, 51, 51, 51, 51, 51, 51, 
	51, 51, 51, 1, 1, 1, 51, 51, 
	51, 51, 51, 51, 51, 51, 51, 51, 
	51, 51, 51, 51, 51, 51, 51, 51, 
	51, 51, 51, 51, 51, 51, 51, 51, 
	51, 51, 51, 51, 51, 51, 51, 1, 
	53, 1, 1, 1, 54, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 53, 
	1, 1, 1, 1, 1, 1, 1, 55, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 56, 1, 57, 1, 1, 1, 
	58, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 57, 1, 1, 1, 1, 
	1, 1, 1, 59, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 60, 1, 
	61, 1, 1, 1, 62, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 61, 
	63, 1, 63, 63, 63, 63, 63, 64, 
	1, 63, 63, 63, 63, 63, 1, 63, 
	63, 63, 63, 63, 63, 63, 63, 63, 
	63, 1, 56, 1, 63, 1, 1, 1, 
	63, 63, 63, 63, 63, 63, 63, 63, 
	63, 63, 63, 63, 63, 63, 63, 63, 
	63, 63, 63, 63, 63, 63, 63, 63, 
	63, 63, 1, 1, 1, 63, 63, 63, 
	63, 63, 63, 63, 63, 63, 63, 63, 
	63, 63, 63, 63, 63, 63, 63, 63, 
	63, 63, 63, 63, 63, 63, 63, 63, 
	63, 63, 63, 63, 63, 63, 1, 35, 
	1, 1, 1, 65, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 35, 1, 
	1, 1, 1, 1, 1, 1, 66, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 2, 1, 67, 1, 1, 1, 68, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 67, 1, 1, 1, 1, 1, 
	1, 1, 69, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 36, 1, 1, 
	0
]

class << self
	attr_accessor :_trans_targs
	private :_trans_targs, :_trans_targs=
end
self._trans_targs = [
	26, 0, 2, 3, 5, 20, 4, 5, 
	6, 7, 8, 29, 10, 17, 7, 8, 
	10, 17, 9, 11, 12, 27, 16, 11, 
	12, 27, 16, 13, 15, 27, 7, 8, 
	10, 17, 19, 30, 2, 3, 5, 20, 
	22, 23, 22, 32, 25, 22, 23, 22, 
	32, 25, 24, 26, 2, 27, 14, 28, 
	2, 27, 14, 28, 2, 30, 18, 29, 
	31, 18, 31, 30, 18, 31
]

class << self
	attr_accessor :_trans_actions
	private :_trans_actions, :_trans_actions=
end
self._trans_actions = [
	1, 0, 0, 0, 2, 3, 0, 0, 
	4, 5, 5, 5, 5, 6, 0, 0, 
	0, 3, 0, 7, 7, 8, 7, 0, 
	0, 9, 0, 0, 0, 0, 10, 10, 
	10, 11, 0, 0, 10, 10, 12, 11, 
	13, 13, 14, 15, 13, 0, 0, 3, 
	16, 0, 0, 0, 17, 18, 18, 19, 
	18, 20, 20, 21, 20, 18, 18, 0, 
	22, 0, 3, 10, 10, 11
]

class << self
	attr_accessor :_eof_actions
	private :_eof_actions, :_eof_actions=
end
self._eof_actions = [
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 17, 18, 20, 18, 0, 10, 
	0
]

class << self
	attr_accessor :start
end
self.start = 1;
class << self
	attr_accessor :first_final
end
self.first_final = 26;
class << self
	attr_accessor :error
end
self.error = 0;

class << self
	attr_accessor :en_comment_tail
end
self.en_comment_tail = 21;
class << self
	attr_accessor :en_main
end
self.en_main = 1;



    def self.parse(data)
      content_disposition = ContentDispositionStruct.new('', [])
      return content_disposition if Mail::Utilities.blank?(data)

      # Parser state
      disp_type_s = param_attr_s = param_attr = qstr_s = qstr = param_val_s = nil

      # 5.1 Variables Used by Ragel
      p = 0
      eof = pe = data.length
      stack = []

      
begin
	p ||= 0
	pe ||= data.length
	cs = start
	top = 0
end

      
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
	_inds = _index_offsets[cs]
	_slen = _key_spans[cs]
	_wide = data[p].ord
	_trans = if (   _slen > 0 && 
			_trans_keys[_keys] <= _wide && 
			_wide <= _trans_keys[_keys + 1] 
		    ) then
			_indicies[ _inds + _wide - _trans_keys[_keys] ] 
		 else 
			_indicies[ _inds + _slen ]
		 end
	cs = _trans_targs[_trans]
	if _trans_actions[_trans] != 0
	case _trans_actions[_trans]
	when 1 then
		begin
 disp_type_s = p 		end
	when 17 then
		begin
 content_disposition.disposition_type = data[disp_type_s..(p-1)].downcase 		end
	when 2 then
		begin
 param_attr_s = p 		end
	when 4 then
		begin
 param_attr = data[param_attr_s..(p-1)] 		end
	when 7 then
		begin
 qstr_s = p 		end
	when 9 then
		begin
 qstr = data[qstr_s..(p-1)] 		end
	when 5 then
		begin
 param_val_s = p 		end
	when 18 then
		begin

    if param_attr.nil?
      raise Mail::Field::ParseError.new(Mail::ContentDispositionElement, data, "no attribute for value")
    end

    # Use quoted string value if one exists, otherwise use parameter value
    value = qstr || data[param_val_s..(p-1)]

    content_disposition.parameters << { param_attr => value }
    param_attr = nil
    qstr = nil
  		end
	when 10 then
		begin
 		end
	when 13 then
		begin
 		end
	when 3 then
		begin
 	begin
		stack[top] = cs
		top+= 1
		cs = 21
		_goto_level = _again
		next
	end
 		end
	when 16 then
		begin
 	begin
		top -= 1
		cs = stack[top]
		_goto_level = _again
		next
	end
 		end
	when 8 then
		begin
 qstr_s = p 		end
		begin
 qstr = data[qstr_s..(p-1)] 		end
	when 6 then
		begin
 param_val_s = p 		end
		begin
 	begin
		stack[top] = cs
		top+= 1
		cs = 21
		_goto_level = _again
		next
	end
 		end
	when 22 then
		begin

    if param_attr.nil?
      raise Mail::Field::ParseError.new(Mail::ContentDispositionElement, data, "no attribute for value")
    end

    # Use quoted string value if one exists, otherwise use parameter value
    value = qstr || data[param_val_s..(p-1)]

    content_disposition.parameters << { param_attr => value }
    param_attr = nil
    qstr = nil
  		end
		begin
 	begin
		stack[top] = cs
		top+= 1
		cs = 21
		_goto_level = _again
		next
	end
 		end
	when 12 then
		begin
 		end
		begin
 param_attr_s = p 		end
	when 20 then
		begin
 		end
		begin

    if param_attr.nil?
      raise Mail::Field::ParseError.new(Mail::ContentDispositionElement, data, "no attribute for value")
    end

    # Use quoted string value if one exists, otherwise use parameter value
    value = qstr || data[param_val_s..(p-1)]

    content_disposition.parameters << { param_attr => value }
    param_attr = nil
    qstr = nil
  		end
	when 11 then
		begin
 		end
		begin
 	begin
		stack[top] = cs
		top+= 1
		cs = 21
		_goto_level = _again
		next
	end
 		end
	when 14 then
		begin
 		end
		begin
 	begin
		stack[top] = cs
		top+= 1
		cs = 21
		_goto_level = _again
		next
	end
 		end
	when 15 then
		begin
 		end
		begin
 	begin
		top -= 1
		cs = stack[top]
		_goto_level = _again
		next
	end
 		end
	when 19 then
		begin
 	begin
		stack[top] = cs
		top+= 1
		cs = 21
		_goto_level = _again
		next
	end
 		end
		begin

    if param_attr.nil?
      raise Mail::Field::ParseError.new(Mail::ContentDispositionElement, data, "no attribute for value")
    end

    # Use quoted string value if one exists, otherwise use parameter value
    value = qstr || data[param_val_s..(p-1)]

    content_disposition.parameters << { param_attr => value }
    param_attr = nil
    qstr = nil
  		end
	when 21 then
		begin
 		end
		begin
 	begin
		stack[top] = cs
		top+= 1
		cs = 21
		_goto_level = _again
		next
	end
 		end
		begin

    if param_attr.nil?
      raise Mail::Field::ParseError.new(Mail::ContentDispositionElement, data, "no attribute for value")
    end

    # Use quoted string value if one exists, otherwise use parameter value
    value = qstr || data[param_val_s..(p-1)]

    content_disposition.parameters << { param_attr => value }
    param_attr = nil
    qstr = nil
  		end
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
	  case _eof_actions[cs]
	when 17 then
		begin
 content_disposition.disposition_type = data[disp_type_s..(p-1)].downcase 		end
	when 18 then
		begin

    if param_attr.nil?
      raise Mail::Field::ParseError.new(Mail::ContentDispositionElement, data, "no attribute for value")
    end

    # Use quoted string value if one exists, otherwise use parameter value
    value = qstr || data[param_val_s..(p-1)]

    content_disposition.parameters << { param_attr => value }
    param_attr = nil
    qstr = nil
  		end
	when 10 then
		begin
 		end
	when 20 then
		begin
 		end
		begin

    if param_attr.nil?
      raise Mail::Field::ParseError.new(Mail::ContentDispositionElement, data, "no attribute for value")
    end

    # Use quoted string value if one exists, otherwise use parameter value
    value = qstr || data[param_val_s..(p-1)]

    content_disposition.parameters << { param_attr => value }
    param_attr = nil
    qstr = nil
  		end
	  end
	end

	end
	if _goto_level <= _out
		break
	end
end
	end


      if p != eof || cs < 26
        raise Mail::Field::ParseError.new(Mail::ContentDispositionElement, data, "Only able to parse up to #{data[0..p]}")
      end

      content_disposition
    end
  end
end
