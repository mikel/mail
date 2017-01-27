
# frozen_string_literal: true
require 'mail/utilities'




module Mail::Parsers
  module ContentLocationParser
    ContentLocationStruct = Struct.new(:location, :error)

    
class << self
	attr_accessor :_trans_keys
	private :_trans_keys, :_trans_keys=
end
self._trans_keys = [
	0, 0, 9, 126, 10, 10, 
	9, 32, 10, 10, 9, 
	32, 1, 127, 10, 10, 
	9, 32, 0, 127, 10, 10, 
	9, 32, 9, 126, 1, 
	127, 1, 127, 10, 10, 
	9, 32, 0, 127, 9, 126, 
	9, 40, 9, 40, 1, 
	127, 1, 127, 1, 127, 
	1, 127, 9, 126, 0, 0, 
	0
]

class << self
	attr_accessor :_key_spans
	private :_key_spans, :_key_spans=
end
self._key_spans = [
	0, 118, 1, 24, 1, 24, 127, 1, 
	24, 128, 1, 24, 118, 127, 127, 1, 
	24, 128, 118, 32, 32, 127, 127, 127, 
	127, 118, 0
]

class << self
	attr_accessor :_index_offsets
	private :_index_offsets, :_index_offsets=
end
self._index_offsets = [
	0, 0, 119, 121, 146, 148, 173, 301, 
	303, 328, 457, 459, 484, 603, 731, 859, 
	861, 886, 1015, 1134, 1167, 1200, 1328, 1456, 
	1584, 1712, 1831
]

class << self
	attr_accessor :_indicies
	private :_indicies, :_indicies=
end
self._indicies = [
	0, 1, 1, 1, 2, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 0, 
	3, 4, 3, 3, 3, 3, 3, 5, 
	1, 3, 3, 3, 3, 3, 1, 3, 
	3, 3, 3, 3, 3, 3, 3, 3, 
	3, 1, 1, 1, 3, 1, 1, 1, 
	3, 3, 3, 3, 3, 3, 3, 3, 
	3, 3, 3, 3, 3, 3, 3, 3, 
	3, 3, 3, 3, 3, 3, 3, 3, 
	3, 3, 1, 1, 1, 3, 3, 3, 
	3, 3, 3, 3, 3, 3, 3, 3, 
	3, 3, 3, 3, 3, 3, 3, 3, 
	3, 3, 3, 3, 3, 3, 3, 3, 
	3, 3, 3, 3, 3, 3, 1, 6, 
	1, 0, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	0, 1, 7, 1, 8, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 8, 1, 9, 9, 9, 
	9, 9, 9, 9, 9, 9, 1, 9, 
	9, 10, 9, 9, 9, 9, 9, 9, 
	9, 9, 9, 9, 9, 9, 9, 9, 
	9, 9, 9, 9, 9, 9, 11, 9, 
	9, 9, 9, 9, 9, 9, 9, 9, 
	9, 9, 9, 9, 9, 9, 9, 9, 
	9, 9, 9, 9, 9, 9, 9, 9, 
	9, 9, 9, 9, 9, 9, 9, 9, 
	9, 9, 9, 9, 9, 9, 9, 9, 
	9, 9, 9, 9, 9, 9, 9, 9, 
	9, 9, 9, 9, 9, 9, 9, 9, 
	12, 9, 9, 9, 9, 9, 9, 9, 
	9, 9, 9, 9, 9, 9, 9, 9, 
	9, 9, 9, 9, 9, 9, 9, 9, 
	9, 9, 9, 9, 9, 9, 9, 9, 
	9, 9, 9, 9, 1, 13, 1, 9, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 9, 1, 
	9, 9, 9, 9, 9, 9, 9, 9, 
	9, 9, 9, 9, 9, 9, 9, 9, 
	9, 9, 9, 9, 9, 9, 9, 9, 
	9, 9, 9, 9, 9, 9, 9, 9, 
	9, 9, 9, 9, 9, 9, 9, 9, 
	9, 9, 9, 9, 9, 9, 9, 9, 
	9, 9, 9, 9, 9, 9, 9, 9, 
	9, 9, 9, 9, 9, 9, 9, 9, 
	9, 9, 9, 9, 9, 9, 9, 9, 
	9, 9, 9, 9, 9, 9, 9, 9, 
	9, 9, 9, 9, 9, 9, 9, 9, 
	9, 9, 9, 9, 9, 9, 9, 9, 
	9, 9, 9, 9, 9, 9, 9, 9, 
	9, 9, 9, 9, 9, 9, 9, 9, 
	9, 9, 9, 9, 9, 9, 9, 9, 
	9, 9, 9, 9, 9, 9, 9, 9, 
	1, 14, 1, 15, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 15, 1, 16, 1, 1, 1, 
	17, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 16, 18, 19, 18, 18, 
	18, 18, 18, 20, 1, 18, 18, 18, 
	18, 18, 1, 18, 18, 18, 18, 18, 
	18, 18, 18, 18, 18, 1, 1, 1, 
	18, 1, 1, 1, 18, 18, 18, 18, 
	18, 18, 18, 18, 18, 18, 18, 18, 
	18, 18, 18, 18, 18, 18, 18, 18, 
	18, 18, 18, 18, 18, 18, 1, 1, 
	1, 18, 18, 18, 18, 18, 18, 18, 
	18, 18, 18, 18, 18, 18, 18, 18, 
	18, 18, 18, 18, 18, 18, 18, 18, 
	18, 18, 18, 18, 18, 18, 18, 18, 
	18, 18, 1, 21, 21, 21, 21, 21, 
	21, 21, 21, 21, 1, 21, 21, 22, 
	21, 21, 21, 21, 21, 21, 21, 21, 
	21, 21, 21, 21, 21, 21, 21, 21, 
	21, 21, 21, 21, 21, 21, 21, 21, 
	21, 21, 23, 24, 21, 21, 21, 21, 
	21, 21, 21, 21, 21, 21, 21, 21, 
	21, 21, 21, 21, 21, 21, 21, 21, 
	21, 21, 21, 21, 21, 21, 21, 21, 
	21, 21, 21, 21, 21, 21, 21, 21, 
	21, 21, 21, 21, 21, 21, 21, 21, 
	21, 21, 21, 21, 21, 21, 25, 21, 
	21, 21, 21, 21, 21, 21, 21, 21, 
	21, 21, 21, 21, 21, 21, 21, 21, 
	21, 21, 21, 21, 21, 21, 21, 21, 
	21, 21, 21, 21, 21, 21, 21, 21, 
	21, 21, 1, 26, 26, 26, 26, 26, 
	26, 26, 26, 26, 1, 26, 26, 27, 
	26, 26, 26, 26, 26, 26, 26, 26, 
	26, 26, 26, 26, 26, 26, 26, 26, 
	26, 26, 26, 26, 26, 26, 26, 26, 
	26, 26, 28, 29, 26, 26, 26, 26, 
	26, 26, 26, 26, 26, 26, 26, 26, 
	26, 26, 26, 26, 26, 26, 26, 26, 
	26, 26, 26, 26, 26, 26, 26, 26, 
	26, 26, 26, 26, 26, 26, 26, 26, 
	26, 26, 26, 26, 26, 26, 26, 26, 
	26, 26, 26, 26, 26, 26, 30, 26, 
	26, 26, 26, 26, 26, 26, 26, 26, 
	26, 26, 26, 26, 26, 26, 26, 26, 
	26, 26, 26, 26, 26, 26, 26, 26, 
	26, 26, 26, 26, 26, 26, 26, 26, 
	26, 26, 1, 31, 1, 26, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 26, 1, 26, 26, 
	26, 26, 26, 26, 26, 26, 26, 26, 
	26, 26, 26, 26, 26, 26, 26, 26, 
	26, 26, 26, 26, 26, 26, 26, 26, 
	26, 26, 26, 26, 26, 26, 26, 26, 
	26, 26, 26, 26, 26, 26, 26, 26, 
	26, 26, 26, 26, 26, 26, 26, 26, 
	26, 26, 26, 26, 26, 26, 26, 26, 
	26, 26, 26, 26, 26, 26, 26, 26, 
	26, 26, 26, 26, 26, 26, 26, 26, 
	26, 26, 26, 26, 26, 26, 26, 26, 
	26, 26, 26, 26, 26, 26, 26, 26, 
	26, 26, 26, 26, 26, 26, 26, 26, 
	26, 26, 26, 26, 26, 26, 26, 26, 
	26, 26, 26, 26, 26, 26, 26, 26, 
	26, 26, 26, 26, 26, 26, 26, 26, 
	26, 26, 26, 26, 26, 26, 1, 32, 
	1, 1, 1, 33, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 32, 34, 
	34, 34, 34, 34, 34, 34, 35, 1, 
	34, 34, 34, 34, 34, 1, 34, 34, 
	34, 34, 34, 34, 34, 34, 34, 34, 
	1, 1, 1, 34, 1, 1, 1, 34, 
	34, 34, 34, 34, 34, 34, 34, 34, 
	34, 34, 34, 34, 34, 34, 34, 34, 
	34, 34, 34, 34, 34, 34, 34, 34, 
	34, 1, 1, 1, 34, 34, 34, 34, 
	34, 34, 34, 34, 34, 34, 34, 34, 
	34, 34, 34, 34, 34, 34, 34, 34, 
	34, 34, 34, 34, 34, 34, 34, 34, 
	34, 34, 34, 34, 34, 1, 8, 1, 
	1, 1, 36, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 8, 1, 1, 
	1, 1, 1, 1, 1, 37, 1, 38, 
	1, 1, 1, 39, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 38, 1, 
	1, 1, 1, 1, 1, 1, 40, 1, 
	41, 41, 41, 41, 41, 41, 41, 41, 
	42, 1, 41, 41, 43, 41, 41, 41, 
	41, 41, 41, 41, 41, 41, 41, 41, 
	41, 41, 41, 41, 41, 41, 41, 42, 
	44, 45, 44, 44, 44, 44, 44, 46, 
	41, 44, 44, 44, 44, 44, 41, 44, 
	44, 44, 44, 44, 44, 44, 44, 44, 
	44, 41, 41, 41, 44, 41, 41, 41, 
	44, 44, 44, 44, 44, 44, 44, 44, 
	44, 44, 44, 44, 44, 44, 44, 44, 
	44, 44, 44, 44, 44, 44, 44, 44, 
	44, 44, 41, 47, 41, 44, 44, 44, 
	44, 44, 44, 44, 44, 44, 44, 44, 
	44, 44, 44, 44, 44, 44, 44, 44, 
	44, 44, 44, 44, 44, 44, 44, 44, 
	44, 44, 44, 44, 44, 44, 41, 1, 
	9, 9, 9, 9, 9, 9, 9, 9, 
	15, 1, 9, 9, 48, 9, 9, 9, 
	9, 9, 9, 9, 9, 9, 9, 9, 
	9, 9, 9, 9, 9, 9, 9, 15, 
	9, 11, 9, 9, 9, 9, 9, 49, 
	9, 9, 9, 9, 9, 9, 9, 9, 
	9, 9, 9, 9, 9, 9, 9, 9, 
	9, 9, 9, 9, 9, 9, 9, 9, 
	9, 9, 9, 9, 9, 9, 9, 9, 
	9, 9, 9, 9, 9, 9, 9, 9, 
	9, 9, 9, 9, 9, 9, 9, 9, 
	9, 9, 9, 12, 9, 9, 9, 9, 
	9, 9, 9, 9, 9, 9, 9, 9, 
	9, 9, 9, 9, 9, 9, 9, 9, 
	9, 9, 9, 9, 9, 9, 9, 9, 
	9, 9, 9, 9, 9, 9, 9, 1, 
	9, 9, 9, 9, 9, 9, 9, 9, 
	50, 1, 9, 9, 51, 9, 9, 9, 
	9, 9, 9, 9, 9, 9, 9, 9, 
	9, 9, 9, 9, 9, 9, 9, 50, 
	9, 11, 9, 9, 9, 9, 9, 52, 
	9, 9, 9, 9, 9, 9, 9, 9, 
	9, 9, 9, 9, 9, 9, 9, 9, 
	9, 9, 9, 9, 9, 9, 9, 9, 
	9, 9, 9, 9, 9, 9, 9, 9, 
	9, 9, 9, 9, 9, 9, 9, 9, 
	9, 9, 9, 9, 9, 9, 9, 9, 
	9, 9, 9, 12, 9, 9, 9, 9, 
	9, 9, 9, 9, 9, 9, 9, 9, 
	9, 9, 9, 9, 9, 9, 9, 9, 
	9, 9, 9, 9, 9, 9, 9, 9, 
	9, 9, 9, 9, 9, 9, 9, 1, 
	9, 9, 9, 9, 9, 9, 9, 9, 
	53, 1, 9, 9, 54, 9, 9, 9, 
	9, 9, 9, 9, 9, 9, 9, 9, 
	9, 9, 9, 9, 9, 9, 9, 53, 
	55, 56, 55, 55, 55, 55, 55, 57, 
	9, 55, 55, 55, 55, 55, 9, 55, 
	55, 55, 55, 55, 55, 55, 55, 55, 
	55, 9, 9, 9, 55, 9, 9, 9, 
	55, 55, 55, 55, 55, 55, 55, 55, 
	55, 55, 55, 55, 55, 55, 55, 55, 
	55, 55, 55, 55, 55, 55, 55, 55, 
	55, 55, 9, 12, 9, 55, 55, 55, 
	55, 55, 55, 55, 55, 55, 55, 55, 
	55, 55, 55, 55, 55, 55, 55, 55, 
	55, 55, 55, 55, 55, 55, 55, 55, 
	55, 55, 55, 55, 55, 55, 9, 1, 
	32, 1, 1, 1, 33, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 32, 
	34, 34, 34, 34, 34, 34, 34, 58, 
	1, 34, 34, 34, 34, 34, 1, 34, 
	34, 34, 34, 34, 34, 34, 34, 34, 
	34, 1, 1, 1, 34, 1, 1, 1, 
	34, 34, 34, 34, 34, 34, 34, 34, 
	34, 34, 34, 34, 34, 34, 34, 34, 
	34, 34, 34, 34, 34, 34, 34, 34, 
	34, 34, 1, 1, 1, 34, 34, 34, 
	34, 34, 34, 34, 34, 34, 34, 34, 
	34, 34, 34, 34, 34, 34, 34, 34, 
	34, 34, 34, 34, 34, 34, 34, 34, 
	34, 34, 34, 34, 34, 34, 1, 1, 
	0
]

class << self
	attr_accessor :_trans_targs
	private :_trans_targs, :_trans_targs=
end
self._trans_targs = [
	1, 0, 2, 18, 21, 12, 3, 5, 
	19, 6, 7, 19, 9, 8, 11, 22, 
	1, 2, 18, 21, 12, 14, 15, 14, 
	26, 17, 14, 15, 14, 26, 17, 16, 
	19, 4, 18, 20, 4, 20, 19, 4, 
	20, 6, 22, 10, 24, 25, 23, 9, 
	10, 23, 22, 10, 23, 22, 10, 24, 
	25, 23, 20
]

class << self
	attr_accessor :_trans_actions
	private :_trans_actions, :_trans_actions=
end
self._trans_actions = [
	0, 0, 0, 1, 1, 2, 0, 0, 
	0, 0, 0, 3, 0, 0, 0, 0, 
	4, 4, 5, 5, 6, 7, 7, 8, 
	9, 7, 0, 0, 2, 10, 0, 0, 
	11, 11, 0, 12, 0, 2, 4, 4, 
	6, 13, 14, 14, 13, 15, 16, 13, 
	0, 2, 4, 4, 6, 11, 11, 0, 
	3, 12, 17
]

class << self
	attr_accessor :_eof_actions
	private :_eof_actions, :_eof_actions=
end
self._eof_actions = [
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 11, 0, 4, 11, 0, 4, 
	11, 11, 0
]

class << self
	attr_accessor :start
end
self.start = 1;
class << self
	attr_accessor :first_final
end
self.first_final = 18;
class << self
	attr_accessor :error
end
self.error = 0;

class << self
	attr_accessor :en_comment_tail
end
self.en_comment_tail = 13;
class << self
	attr_accessor :en_main
end
self.en_main = 1;



    def self.parse(data)
      content_location = ContentLocationStruct.new(nil)
      return content_location if Mail::Utilities.blank?(data)

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
	when 13 then
		begin
 qstr_s = p 		end
	when 3 then
		begin
 content_location.location = data[qstr_s..(p-1)] 		end
	when 1 then
		begin
 token_string_s = p 		end
	when 11 then
		begin
 content_location.location = data[token_string_s..(p-1)] 		end
	when 4 then
		begin
 		end
	when 7 then
		begin
 		end
	when 2 then
		begin
 	begin
		stack[top] = cs
		top+= 1
		cs = 13
		_goto_level = _again
		next
	end
 		end
	when 10 then
		begin
 	begin
		top -= 1
		cs = stack[top]
		_goto_level = _again
		next
	end
 		end
	when 15 then
		begin
 qstr_s = p 		end
		begin
 content_location.location = data[qstr_s..(p-1)] 		end
	when 14 then
		begin
 qstr_s = p 		end
		begin
 content_location.location = data[token_string_s..(p-1)] 		end
	when 12 then
		begin
 content_location.location = data[token_string_s..(p-1)] 		end
		begin
 	begin
		stack[top] = cs
		top+= 1
		cs = 13
		_goto_level = _again
		next
	end
 		end
	when 5 then
		begin
 		end
		begin
 token_string_s = p 		end
	when 6 then
		begin
 		end
		begin
 	begin
		stack[top] = cs
		top+= 1
		cs = 13
		_goto_level = _again
		next
	end
 		end
	when 8 then
		begin
 		end
		begin
 	begin
		stack[top] = cs
		top+= 1
		cs = 13
		_goto_level = _again
		next
	end
 		end
	when 9 then
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
	when 17 then
		begin
 	begin
		stack[top] = cs
		top+= 1
		cs = 13
		_goto_level = _again
		next
	end
 		end
		begin
 content_location.location = data[token_string_s..(p-1)] 		end
	when 16 then
		begin
 qstr_s = p 		end
		begin
 content_location.location = data[token_string_s..(p-1)] 		end
		begin
 	begin
		stack[top] = cs
		top+= 1
		cs = 13
		_goto_level = _again
		next
	end
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
	when 11 then
		begin
 content_location.location = data[token_string_s..(p-1)] 		end
	when 4 then
		begin
 		end
	  end
	end

	end
	if _goto_level <= _out
		break
	end
end
	end


      if p != eof || cs < 18
        raise Mail::Field::ParseError.new(Mail::ContentLocationElement, data, "Only able to parse up to #{data[0..p]}")
      end

      content_location
    end
  end
end
