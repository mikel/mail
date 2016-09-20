
# line 1 "lib/mail/parsers/ragel/ruby/machines/phrase_lists_machine.rl"

# line 8 "lib/mail/parsers/ragel/ruby/machines/phrase_lists_machine.rl"


module Mail
  module Parsers
    module Ragel
      module PhraseListsMachine
        
# line 13 "lib/mail/parsers/ragel/ruby/machines/phrase_lists_machine.rb"
class << self
	attr_accessor :_trans_keys
	private :_trans_keys, :_trans_keys=
end
self._trans_keys = [
	0, 0, 9, 126, 9, 126, 
	10, 10, 9, 32, 10, 
	10, 9, 32, 1, 127, 
	1, 127, 10, 10, 9, 32, 
	0, 127, 9, 126, 10, 
	10, 9, 32, 9, 126, 
	1, 127, 1, 127, 10, 10, 
	9, 32, 0, 127, 9, 
	126, 9, 126, 9, 126, 
	0, 0, 0
]

class << self
	attr_accessor :_key_spans
	private :_key_spans, :_key_spans=
end
self._key_spans = [
	0, 118, 118, 1, 24, 1, 24, 127, 
	127, 1, 24, 128, 118, 1, 24, 118, 
	127, 127, 1, 24, 128, 118, 118, 118, 
	0
]

class << self
	attr_accessor :_index_offsets
	private :_index_offsets, :_index_offsets=
end
self._index_offsets = [
	0, 0, 119, 238, 240, 265, 267, 292, 
	420, 548, 550, 575, 704, 823, 825, 850, 
	969, 1097, 1225, 1227, 1252, 1381, 1500, 1619, 
	1738
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
	1, 3, 3, 1, 3, 6, 3, 3, 
	3, 3, 3, 3, 3, 3, 3, 3, 
	3, 1, 1, 1, 3, 1, 3, 6, 
	3, 3, 3, 3, 3, 3, 3, 3, 
	3, 3, 3, 3, 3, 3, 3, 3, 
	3, 3, 3, 3, 3, 3, 3, 3, 
	3, 3, 1, 1, 1, 3, 3, 3, 
	3, 3, 3, 3, 3, 3, 3, 3, 
	3, 3, 3, 3, 3, 3, 3, 3, 
	3, 3, 3, 3, 3, 3, 3, 3, 
	3, 3, 3, 3, 3, 3, 1, 7, 
	1, 1, 1, 8, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 7, 9, 
	10, 9, 9, 9, 9, 9, 11, 1, 
	9, 9, 1, 9, 1, 9, 9, 9, 
	9, 9, 9, 9, 9, 9, 9, 9, 
	1, 1, 1, 9, 1, 9, 1, 9, 
	9, 9, 9, 9, 9, 9, 9, 9, 
	9, 9, 9, 9, 9, 9, 9, 9, 
	9, 9, 9, 9, 9, 9, 9, 9, 
	9, 1, 1, 1, 9, 9, 9, 9, 
	9, 9, 9, 9, 9, 9, 9, 9, 
	9, 9, 9, 9, 9, 9, 9, 9, 
	9, 9, 9, 9, 9, 9, 9, 9, 
	9, 9, 9, 9, 9, 1, 12, 1, 
	7, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 7, 
	1, 13, 1, 9, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 9, 1, 14, 14, 14, 14, 
	14, 14, 14, 14, 14, 1, 14, 14, 
	15, 14, 14, 14, 14, 14, 14, 14, 
	14, 14, 14, 14, 14, 14, 14, 14, 
	14, 14, 14, 14, 14, 16, 14, 14, 
	14, 14, 14, 14, 14, 14, 14, 14, 
	14, 14, 14, 14, 14, 14, 14, 14, 
	14, 14, 14, 14, 14, 14, 14, 14, 
	14, 14, 14, 14, 14, 14, 14, 14, 
	14, 14, 14, 14, 14, 14, 14, 14, 
	14, 14, 14, 14, 14, 14, 14, 14, 
	14, 14, 14, 14, 14, 14, 14, 17, 
	14, 14, 14, 14, 14, 14, 14, 14, 
	14, 14, 14, 14, 14, 14, 14, 14, 
	14, 14, 14, 14, 14, 14, 14, 14, 
	14, 14, 14, 14, 14, 14, 14, 14, 
	14, 14, 14, 1, 18, 18, 18, 18, 
	18, 18, 18, 18, 18, 1, 18, 18, 
	19, 18, 18, 18, 18, 18, 18, 18, 
	18, 18, 18, 18, 18, 18, 18, 18, 
	18, 18, 18, 18, 18, 20, 18, 18, 
	18, 18, 18, 18, 18, 18, 18, 18, 
	18, 18, 18, 18, 18, 18, 18, 18, 
	18, 18, 18, 18, 18, 18, 18, 18, 
	18, 18, 18, 18, 18, 18, 18, 18, 
	18, 18, 18, 18, 18, 18, 18, 18, 
	18, 18, 18, 18, 18, 18, 18, 18, 
	18, 18, 18, 18, 18, 18, 18, 21, 
	18, 18, 18, 18, 18, 18, 18, 18, 
	18, 18, 18, 18, 18, 18, 18, 18, 
	18, 18, 18, 18, 18, 18, 18, 18, 
	18, 18, 18, 18, 18, 18, 18, 18, 
	18, 18, 18, 1, 22, 1, 18, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 18, 1, 18, 
	18, 18, 18, 18, 18, 18, 18, 18, 
	18, 18, 18, 18, 18, 18, 18, 18, 
	18, 18, 18, 18, 18, 18, 18, 18, 
	18, 18, 18, 18, 18, 18, 18, 18, 
	18, 18, 18, 18, 18, 18, 18, 18, 
	18, 18, 18, 18, 18, 18, 18, 18, 
	18, 18, 18, 18, 18, 18, 18, 18, 
	18, 18, 18, 18, 18, 18, 18, 18, 
	18, 18, 18, 18, 18, 18, 18, 18, 
	18, 18, 18, 18, 18, 18, 18, 18, 
	18, 18, 18, 18, 18, 18, 18, 18, 
	18, 18, 18, 18, 18, 18, 18, 18, 
	18, 18, 18, 18, 18, 18, 18, 18, 
	18, 18, 18, 18, 18, 18, 18, 18, 
	18, 18, 18, 18, 18, 18, 18, 18, 
	18, 18, 18, 18, 18, 18, 18, 1, 
	23, 1, 1, 1, 24, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 23, 
	3, 4, 3, 3, 3, 3, 3, 5, 
	1, 3, 3, 1, 3, 6, 3, 3, 
	3, 3, 3, 3, 3, 3, 3, 3, 
	3, 1, 1, 1, 3, 1, 3, 6, 
	3, 3, 3, 3, 3, 3, 3, 3, 
	3, 3, 3, 3, 3, 3, 3, 3, 
	3, 3, 3, 3, 3, 3, 3, 3, 
	3, 3, 1, 1, 1, 3, 3, 3, 
	3, 3, 3, 3, 3, 3, 3, 3, 
	3, 3, 3, 3, 3, 3, 3, 3, 
	3, 3, 3, 3, 3, 3, 3, 3, 
	3, 3, 3, 3, 3, 3, 1, 25, 
	1, 26, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	26, 1, 27, 1, 1, 1, 28, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 27, 29, 30, 29, 29, 29, 29, 
	29, 31, 1, 29, 29, 1, 29, 1, 
	29, 29, 29, 29, 29, 29, 29, 29, 
	29, 29, 29, 1, 1, 1, 29, 1, 
	29, 1, 29, 29, 29, 29, 29, 29, 
	29, 29, 29, 29, 29, 29, 29, 29, 
	29, 29, 29, 29, 29, 29, 29, 29, 
	29, 29, 29, 29, 1, 1, 1, 29, 
	29, 29, 29, 29, 29, 29, 29, 29, 
	29, 29, 29, 29, 29, 29, 29, 29, 
	29, 29, 29, 29, 29, 29, 29, 29, 
	29, 29, 29, 29, 29, 29, 29, 29, 
	1, 32, 32, 32, 32, 32, 32, 32, 
	32, 32, 1, 32, 32, 33, 32, 32, 
	32, 32, 32, 32, 32, 32, 32, 32, 
	32, 32, 32, 32, 32, 32, 32, 32, 
	32, 32, 32, 32, 32, 32, 32, 32, 
	34, 35, 32, 32, 32, 32, 32, 32, 
	32, 32, 32, 32, 32, 32, 32, 32, 
	32, 32, 32, 32, 32, 32, 32, 32, 
	32, 32, 32, 32, 32, 32, 32, 32, 
	32, 32, 32, 32, 32, 32, 32, 32, 
	32, 32, 32, 32, 32, 32, 32, 32, 
	32, 32, 32, 32, 36, 32, 32, 32, 
	32, 32, 32, 32, 32, 32, 32, 32, 
	32, 32, 32, 32, 32, 32, 32, 32, 
	32, 32, 32, 32, 32, 32, 32, 32, 
	32, 32, 32, 32, 32, 32, 32, 32, 
	1, 37, 37, 37, 37, 37, 37, 37, 
	37, 37, 1, 37, 37, 38, 37, 37, 
	37, 37, 37, 37, 37, 37, 37, 37, 
	37, 37, 37, 37, 37, 37, 37, 37, 
	37, 37, 37, 37, 37, 37, 37, 37, 
	39, 40, 37, 37, 37, 37, 37, 37, 
	37, 37, 37, 37, 37, 37, 37, 37, 
	37, 37, 37, 37, 37, 37, 37, 37, 
	37, 37, 37, 37, 37, 37, 37, 37, 
	37, 37, 37, 37, 37, 37, 37, 37, 
	37, 37, 37, 37, 37, 37, 37, 37, 
	37, 37, 37, 37, 41, 37, 37, 37, 
	37, 37, 37, 37, 37, 37, 37, 37, 
	37, 37, 37, 37, 37, 37, 37, 37, 
	37, 37, 37, 37, 37, 37, 37, 37, 
	37, 37, 37, 37, 37, 37, 37, 37, 
	1, 42, 1, 37, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 37, 1, 37, 37, 37, 37, 
	37, 37, 37, 37, 37, 37, 37, 37, 
	37, 37, 37, 37, 37, 37, 37, 37, 
	37, 37, 37, 37, 37, 37, 37, 37, 
	37, 37, 37, 37, 37, 37, 37, 37, 
	37, 37, 37, 37, 37, 37, 37, 37, 
	37, 37, 37, 37, 37, 37, 37, 37, 
	37, 37, 37, 37, 37, 37, 37, 37, 
	37, 37, 37, 37, 37, 37, 37, 37, 
	37, 37, 37, 37, 37, 37, 37, 37, 
	37, 37, 37, 37, 37, 37, 37, 37, 
	37, 37, 37, 37, 37, 37, 37, 37, 
	37, 37, 37, 37, 37, 37, 37, 37, 
	37, 37, 37, 37, 37, 37, 37, 37, 
	37, 37, 37, 37, 37, 37, 37, 37, 
	37, 37, 37, 37, 37, 37, 37, 37, 
	37, 37, 37, 37, 1, 9, 1, 1, 
	1, 43, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 9, 9, 10, 9, 
	9, 9, 9, 9, 44, 1, 9, 9, 
	45, 9, 46, 9, 9, 9, 9, 9, 
	9, 9, 9, 9, 9, 9, 1, 1, 
	1, 9, 1, 9, 46, 9, 9, 9, 
	9, 9, 9, 9, 9, 9, 9, 9, 
	9, 9, 9, 9, 9, 9, 9, 9, 
	9, 9, 9, 9, 9, 9, 9, 1, 
	1, 1, 9, 9, 9, 9, 9, 9, 
	9, 9, 9, 9, 9, 9, 9, 9, 
	9, 9, 9, 9, 9, 9, 9, 9, 
	9, 9, 9, 9, 9, 9, 9, 9, 
	9, 9, 9, 1, 29, 1, 1, 1, 
	47, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 29, 29, 30, 29, 29, 
	29, 29, 29, 48, 1, 29, 29, 49, 
	29, 50, 29, 29, 29, 29, 29, 29, 
	29, 29, 29, 29, 29, 1, 1, 1, 
	29, 1, 29, 50, 29, 29, 29, 29, 
	29, 29, 29, 29, 29, 29, 29, 29, 
	29, 29, 29, 29, 29, 29, 29, 29, 
	29, 29, 29, 29, 29, 29, 1, 1, 
	1, 29, 29, 29, 29, 29, 29, 29, 
	29, 29, 29, 29, 29, 29, 29, 29, 
	29, 29, 29, 29, 29, 29, 29, 29, 
	29, 29, 29, 29, 29, 29, 29, 29, 
	29, 29, 1, 7, 1, 1, 1, 8, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 7, 9, 10, 9, 9, 9, 
	9, 9, 11, 1, 9, 9, 45, 9, 
	46, 9, 9, 9, 9, 9, 9, 9, 
	9, 9, 9, 9, 1, 1, 1, 9, 
	1, 9, 46, 9, 9, 9, 9, 9, 
	9, 9, 9, 9, 9, 9, 9, 9, 
	9, 9, 9, 9, 9, 9, 9, 9, 
	9, 9, 9, 9, 9, 1, 1, 1, 
	9, 9, 9, 9, 9, 9, 9, 9, 
	9, 9, 9, 9, 9, 9, 9, 9, 
	9, 9, 9, 9, 9, 9, 9, 9, 
	9, 9, 9, 9, 9, 9, 9, 9, 
	9, 1, 1, 0
]

class << self
	attr_accessor :_trans_targs
	private :_trans_targs, :_trans_targs=
end
self._trans_targs = [
	2, 0, 3, 21, 7, 15, 23, 2, 
	3, 21, 7, 15, 4, 6, 8, 9, 
	21, 11, 8, 9, 21, 11, 10, 12, 
	13, 14, 12, 2, 3, 21, 7, 15, 
	17, 18, 17, 24, 20, 17, 18, 17, 
	24, 20, 19, 5, 22, 12, 23, 5, 
	22, 12, 23
]

class << self
	attr_accessor :_trans_actions
	private :_trans_actions, :_trans_actions=
end
self._trans_actions = [
	1, 0, 1, 1, 1, 2, 1, 0, 
	0, 0, 0, 3, 0, 0, 4, 4, 
	5, 4, 0, 0, 6, 0, 0, 1, 
	1, 0, 0, 7, 7, 7, 7, 8, 
	9, 9, 10, 11, 9, 0, 0, 3, 
	12, 0, 0, 0, 3, 13, 0, 7, 
	8, 14, 7
]

class << self
	attr_accessor :_eof_actions
	private :_eof_actions, :_eof_actions=
end
self._eof_actions = [
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 13, 14, 13, 
	0
]

class << self
	attr_accessor :start
end
self.start = 1;
class << self
	attr_accessor :first_final
end
self.first_final = 21;
class << self
	attr_accessor :error
end
self.error = 0;

class << self
	attr_accessor :en_comment_tail
end
self.en_comment_tail = 16;
class << self
	attr_accessor :en_main
end
self.en_main = 1;


# line 15 "lib/mail/parsers/ragel/ruby/machines/phrase_lists_machine.rl"

        def self.parse(data)
          # 5.1 Variables Used by Ragel
          p = 0
          eof = pe = data.length
          stack = []

          # Accumulates actions for our own parser
          actions = []

          
# line 352 "lib/mail/parsers/ragel/ruby/machines/phrase_lists_machine.rb"
begin
	p ||= 0
	pe ||= data.length
	cs = start
	top = 0
end

# line 26 "lib/mail/parsers/ragel/ruby/machines/phrase_lists_machine.rl"
          
# line 362 "lib/mail/parsers/ragel/ruby/machines/phrase_lists_machine.rb"
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
	when 7 then
# line 7 "lib/mail/parsers/ragel/ruby/machines/rb_actions.rl"
		begin
 actions.push(4, p) 		end
	when 9 then
# line 8 "lib/mail/parsers/ragel/ruby/machines/rb_actions.rl"
		begin
 actions.push(5, p) 		end
	when 13 then
# line 39 "lib/mail/parsers/ragel/ruby/machines/rb_actions.rl"
		begin
 actions.push(36, p) 		end
	when 1 then
# line 40 "lib/mail/parsers/ragel/ruby/machines/rb_actions.rl"
		begin
 actions.push(37, p) 		end
	when 6 then
# line 41 "lib/mail/parsers/ragel/ruby/machines/rb_actions.rl"
		begin
 actions.push(38, p) 		end
	when 4 then
# line 42 "lib/mail/parsers/ragel/ruby/machines/rb_actions.rl"
		begin
 actions.push(39, p) 		end
	when 3 then
# line 22 "lib/mail/parsers/ragel/ruby/machines/../../rfc5322_lexical_tokens.rl"
		begin
 	begin
		stack[top] = cs
		top+= 1
		cs = 16
		_goto_level = _again
		next
	end
 		end
	when 12 then
# line 23 "lib/mail/parsers/ragel/ruby/machines/../../rfc5322_lexical_tokens.rl"
		begin
 	begin
		top -= 1
		cs = stack[top]
		_goto_level = _again
		next
	end
 		end
	when 14 then
# line 7 "lib/mail/parsers/ragel/ruby/machines/rb_actions.rl"
		begin
 actions.push(4, p) 		end
# line 39 "lib/mail/parsers/ragel/ruby/machines/rb_actions.rl"
		begin
 actions.push(36, p) 		end
	when 8 then
# line 7 "lib/mail/parsers/ragel/ruby/machines/rb_actions.rl"
		begin
 actions.push(4, p) 		end
# line 22 "lib/mail/parsers/ragel/ruby/machines/../../rfc5322_lexical_tokens.rl"
		begin
 	begin
		stack[top] = cs
		top+= 1
		cs = 16
		_goto_level = _again
		next
	end
 		end
	when 10 then
# line 8 "lib/mail/parsers/ragel/ruby/machines/rb_actions.rl"
		begin
 actions.push(5, p) 		end
# line 22 "lib/mail/parsers/ragel/ruby/machines/../../rfc5322_lexical_tokens.rl"
		begin
 	begin
		stack[top] = cs
		top+= 1
		cs = 16
		_goto_level = _again
		next
	end
 		end
	when 11 then
# line 8 "lib/mail/parsers/ragel/ruby/machines/rb_actions.rl"
		begin
 actions.push(5, p) 		end
# line 23 "lib/mail/parsers/ragel/ruby/machines/../../rfc5322_lexical_tokens.rl"
		begin
 	begin
		top -= 1
		cs = stack[top]
		_goto_level = _again
		next
	end
 		end
	when 2 then
# line 40 "lib/mail/parsers/ragel/ruby/machines/rb_actions.rl"
		begin
 actions.push(37, p) 		end
# line 22 "lib/mail/parsers/ragel/ruby/machines/../../rfc5322_lexical_tokens.rl"
		begin
 	begin
		stack[top] = cs
		top+= 1
		cs = 16
		_goto_level = _again
		next
	end
 		end
	when 5 then
# line 42 "lib/mail/parsers/ragel/ruby/machines/rb_actions.rl"
		begin
 actions.push(39, p) 		end
# line 41 "lib/mail/parsers/ragel/ruby/machines/rb_actions.rl"
		begin
 actions.push(38, p) 		end
# line 513 "lib/mail/parsers/ragel/ruby/machines/phrase_lists_machine.rb"
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
	when 13 then
# line 39 "lib/mail/parsers/ragel/ruby/machines/rb_actions.rl"
		begin
 actions.push(36, p) 		end
	when 14 then
# line 7 "lib/mail/parsers/ragel/ruby/machines/rb_actions.rl"
		begin
 actions.push(4, p) 		end
# line 39 "lib/mail/parsers/ragel/ruby/machines/rb_actions.rl"
		begin
 actions.push(36, p) 		end
# line 542 "lib/mail/parsers/ragel/ruby/machines/phrase_lists_machine.rb"
	  end
	end

	end
	if _goto_level <= _out
		break
	end
end
	end

# line 27 "lib/mail/parsers/ragel/ruby/machines/phrase_lists_machine.rl"

          if p == eof && cs >= 21
            return actions, nil
          else
            return [], "Only able to parse up to #{data[0..p]}"
          end
        end
      end
    end
  end
end
