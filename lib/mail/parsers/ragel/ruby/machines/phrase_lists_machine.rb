
# line 1 "phrase_lists_machine.rb.rl"

# line 10 "phrase_lists_machine.rb.rl"


module Mail
	module Parsers
		module Ragel
			module PhraseListsMachine

# line 13 "phrase_lists_machine.rb.rb"
				class << self
					attr_accessor :_phrase_lists_actions
					private :_phrase_lists_actions, :_phrase_lists_actions=
				end
				self._phrase_lists_actions = [
					0, 1, 0, 1, 1, 1, 2, 1,
					3, 1, 4, 1, 5, 1, 6, 1,
					7, 2, 0, 2, 2, 0, 6, 2,
					1, 6, 2, 1, 7, 2, 3, 6,
					2, 5, 4
				]

				class << self
					attr_accessor :_phrase_lists_key_offsets
					private :_phrase_lists_key_offsets, :_phrase_lists_key_offsets=
				end
				self._phrase_lists_key_offsets = [
					0, 0, 18, 36, 37, 39, 40, 42,
					49, 56, 57, 59, 61, 62, 64, 82,
					90, 98, 99, 101, 103, 119, 135, 152,
					169
				]

				class << self
					attr_accessor :_phrase_lists_trans_keys
					private :_phrase_lists_trans_keys, :_phrase_lists_trans_keys=
				end
				self._phrase_lists_trans_keys = [
					9, 13, 32, 34, 40, 46, 61, 64,
					33, 39, 42, 43, 45, 57, 63, 90,
					94, 126, 9, 13, 32, 34, 40, 45,
					61, 63, 33, 39, 42, 43, 47, 57,
					65, 90, 94, 126, 10, 9, 32, 10,
					9, 32, 13, 34, 92, 1, 9, 11,
					127, 13, 34, 92, 1, 9, 11, 127,
					10, 9, 32, 0, 127, 10, 9, 32,
					9, 13, 32, 34, 40, 45, 61, 63,
					33, 39, 42, 43, 47, 57, 65, 90,
					94, 126, 13, 40, 41, 92, 1, 9,
					11, 127, 13, 40, 41, 92, 1, 9,
					11, 127, 10, 9, 32, 0, 127, 9,
					13, 34, 40, 44, 46, 61, 64, 32,
					39, 42, 57, 63, 90, 94, 126, 9,
					13, 34, 40, 44, 46, 61, 64, 32,
					39, 42, 57, 63, 90, 94, 126, 9,
					13, 32, 34, 40, 44, 46, 61, 64,
					33, 39, 42, 57, 63, 90, 94, 126,
					9, 13, 32, 34, 40, 44, 46, 61,
					64, 33, 39, 42, 57, 63, 90, 94,
					126, 0
				]

				class << self
					attr_accessor :_phrase_lists_single_lengths
					private :_phrase_lists_single_lengths, :_phrase_lists_single_lengths=
				end
				self._phrase_lists_single_lengths = [
					0, 8, 8, 1, 2, 1, 2, 3,
					3, 1, 2, 0, 1, 2, 8, 4,
					4, 1, 2, 0, 8, 8, 9, 9,
					0
				]

				class << self
					attr_accessor :_phrase_lists_range_lengths
					private :_phrase_lists_range_lengths, :_phrase_lists_range_lengths=
				end
				self._phrase_lists_range_lengths = [
					0, 5, 5, 0, 0, 0, 0, 2,
					2, 0, 0, 1, 0, 0, 5, 2,
					2, 0, 0, 1, 4, 4, 4, 4,
					0
				]

				class << self
					attr_accessor :_phrase_lists_index_offsets
					private :_phrase_lists_index_offsets, :_phrase_lists_index_offsets=
				end
				self._phrase_lists_index_offsets = [
					0, 0, 14, 28, 30, 33, 35, 38,
					44, 50, 52, 55, 57, 59, 62, 76,
					83, 90, 92, 95, 97, 110, 123, 137,
					151
				]

				class << self
					attr_accessor :_phrase_lists_indicies
					private :_phrase_lists_indicies, :_phrase_lists_indicies=
				end
				self._phrase_lists_indicies = [
					0, 2, 0, 4, 5, 6, 3, 6,
					3, 3, 3, 3, 3, 1, 7, 8,
					7, 10, 11, 9, 9, 9, 9, 9,
					9, 9, 9, 1, 12, 1, 7, 7,
					1, 13, 1, 9, 9, 1, 15, 16,
					17, 14, 14, 1, 19, 20, 21, 18,
					18, 1, 22, 1, 18, 18, 1, 18,
					1, 23, 1, 24, 24, 1, 25, 26,
					25, 28, 29, 27, 27, 27, 27, 27,
					27, 27, 27, 1, 31, 32, 33, 34,
					30, 30, 1, 36, 37, 38, 39, 35,
					35, 1, 40, 1, 35, 35, 1, 35,
					1, 9, 41, 10, 42, 43, 44, 9,
					44, 9, 9, 9, 9, 1, 27, 45,
					28, 46, 47, 48, 27, 48, 27, 27,
					27, 27, 1, 49, 50, 49, 4, 5,
					24, 6, 3, 6, 3, 3, 3, 3,
					1, 7, 8, 7, 10, 11, 43, 44,
					9, 44, 9, 9, 9, 9, 1, 1,
					0
				]

				class << self
					attr_accessor :_phrase_lists_trans_targs
					private :_phrase_lists_trans_targs, :_phrase_lists_trans_targs=
				end
				self._phrase_lists_trans_targs = [
					2, 0, 3, 20, 7, 14, 23, 2,
					3, 20, 7, 14, 4, 6, 8, 9,
					20, 11, 8, 9, 20, 11, 10, 13,
					22, 2, 3, 20, 7, 14, 16, 17,
					16, 24, 19, 16, 17, 16, 24, 19,
					18, 5, 21, 22, 23, 5, 21, 22,
					23, 22, 12
				]

				class << self
					attr_accessor :_phrase_lists_trans_actions
					private :_phrase_lists_trans_actions, :_phrase_lists_trans_actions=
				end
				self._phrase_lists_trans_actions = [
					7, 0, 7, 7, 7, 29, 7, 0,
					0, 0, 0, 13, 0, 0, 11, 11,
					32, 11, 0, 0, 9, 0, 0, 0,
					0, 1, 1, 1, 1, 20, 3, 3,
					23, 26, 3, 0, 0, 13, 15, 0,
					0, 0, 13, 5, 0, 1, 20, 17,
					1, 7, 7
				]

				class << self
					attr_accessor :_phrase_lists_eof_actions
					private :_phrase_lists_eof_actions, :_phrase_lists_eof_actions=
				end
				self._phrase_lists_eof_actions = [
					0, 0, 0, 0, 0, 0, 0, 0,
					0, 0, 0, 0, 0, 0, 0, 0,
					0, 0, 0, 0, 5, 17, 0, 5,
					0
				]

				class << self
					attr_accessor :phrase_lists_start
				end
				self.phrase_lists_start = 1;
				class << self
					attr_accessor :phrase_lists_first_final
				end
				self.phrase_lists_first_final = 20;
				class << self
					attr_accessor :phrase_lists_error
				end
				self.phrase_lists_error = 0;

				class << self
					attr_accessor :phrase_lists_en_comment_tail
				end
				self.phrase_lists_en_comment_tail = 15;
				class << self
					attr_accessor :phrase_lists_en_main
				end
				self.phrase_lists_en_main = 1;


# line 17 "phrase_lists_machine.rb.rl"

				def self.parse(data)
					p = 0
					eof = data.length
					stack = []

					actions = []
					data_unpacked = data.bytes.to_a

# line 198 "phrase_lists_machine.rb.rb"
					begin
						p ||= 0
						pe ||= data.length
						cs = phrase_lists_start
						top = 0
					end

# line 26 "phrase_lists_machine.rb.rl"

# line 208 "phrase_lists_machine.rb.rb"
					begin
						_klen, _trans, _keys, _acts, _nacts = nil
						_goto_level = 0
						_resume = 10
						_eof_trans = 15
						_again = 20
						_test_eof = 30
						_out = 40
						while true
							_trigger_goto = false
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
								_keys = _phrase_lists_key_offsets[cs]
								_trans = _phrase_lists_index_offsets[cs]
								_klen = _phrase_lists_single_lengths[cs]
								_break_match = false

								begin
									if _klen > 0
										_lower = _keys
										_upper = _keys + _klen - 1

										loop do
											break if _upper < _lower
											_mid = _lower + ( (_upper - _lower) >> 1 )

											if ( data_unpacked[p]) < _phrase_lists_trans_keys[_mid]
												_upper = _mid - 1
											elsif ( data_unpacked[p]) > _phrase_lists_trans_keys[_mid]
												_lower = _mid + 1
											else
												_trans += (_mid - _keys)
												_break_match = true
												break
											end
										end # loop
										break if _break_match
										_keys += _klen
										_trans += _klen
									end
									_klen = _phrase_lists_range_lengths[cs]
									if _klen > 0
										_lower = _keys
										_upper = _keys + (_klen << 1) - 2
										loop do
											break if _upper < _lower
											_mid = _lower + (((_upper-_lower) >> 1) & ~1)
											if ( data_unpacked[p]) < _phrase_lists_trans_keys[_mid]
												_upper = _mid - 2
											elsif ( data_unpacked[p]) > _phrase_lists_trans_keys[_mid+1]
												_lower = _mid + 2
											else
												_trans += ((_mid - _keys) >> 1)
												_break_match = true
												break
											end
										end # loop
										break if _break_match
										_trans += _klen
									end
								end while false
								_trans = _phrase_lists_indicies[_trans]
								cs = _phrase_lists_trans_targs[_trans]
								if _phrase_lists_trans_actions[_trans] != 0
									_acts = _phrase_lists_trans_actions[_trans]
									_nacts = _phrase_lists_actions[_acts]
									_acts += 1
									while _nacts > 0
										_nacts -= 1
										_acts += 1
										case _phrase_lists_actions[_acts - 1]
											when 0 then
# line 7 "rb_actions.rl"
												begin
													actions.push(4, p) 		end
											when 1 then
# line 8 "rb_actions.rl"
												begin
													actions.push(5, p) 		end
											when 2 then
# line 39 "rb_actions.rl"
												begin
													actions.push(36, p) 		end
											when 3 then
# line 40 "rb_actions.rl"
												begin
													actions.push(37, p) 		end
											when 4 then
# line 41 "rb_actions.rl"
												begin
													actions.push(38, p) 		end
											when 5 then
# line 42 "rb_actions.rl"
												begin
													actions.push(39, p) 		end
											when 6 then
# line 5 "../../common.rl"
												begin
													begin
														stack[top] = cs
														top+= 1
														cs = 15
														_trigger_goto = true
														_goto_level = _again
														break
													end
												end
											when 7 then
# line 6 "../../common.rl"
												begin
													begin
														top -= 1
														cs = stack[top]
														_trigger_goto = true
														_goto_level = _again
														break
													end
												end
# line 336 "phrase_lists_machine.rb.rb"
										end # action switch
									end
								end
								if _trigger_goto
									next
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
									__acts = _phrase_lists_eof_actions[cs]
									__nacts =  _phrase_lists_actions[__acts]
									__acts += 1
									while __nacts > 0
										__nacts -= 1
										__acts += 1
										case _phrase_lists_actions[__acts - 1]
											when 0 then
# line 7 "rb_actions.rl"
												begin
													actions.push(4, p) 		end
											when 2 then
# line 39 "rb_actions.rl"
												begin
													actions.push(36, p) 		end
# line 372 "phrase_lists_machine.rb.rb"
										end # eof action switch
									end
									if _trigger_goto
										next
									end
								end
							end
							if _goto_level <= _out
								break
							end
						end
					end

# line 27 "phrase_lists_machine.rb.rl"

					if p == eof && cs >= 20
						return actions, nil
					else
						return [], "Only able to parse up to #{data[0..p]}"
					end
				end
			end
		end
	end
end
