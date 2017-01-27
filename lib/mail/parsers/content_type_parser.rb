
# frozen_string_literal: true
require 'mail/utilities'




module Mail::Parsers
  module ContentTypeParser
    ContentTypeStruct = Struct.new(:main_type, :sub_type, :parameters, :error)

    
class << self
	attr_accessor :_trans_keys
	private :_trans_keys, :_trans_keys=
end
self._trans_keys = [
	0, 0, 33, 126, 33, 126, 
	33, 126, 9, 126, 10, 
	10, 9, 32, 33, 126, 
	9, 126, 9, 40, 10, 10, 
	9, 32, 1, 127, 1, 
	127, 10, 10, 9, 32, 
	10, 10, 9, 32, 9, 126, 
	9, 126, 10, 10, 9, 
	32, 9, 126, 0, 127, 
	9, 40, 10, 10, 9, 32, 
	9, 126, 1, 127, 1, 
	127, 10, 10, 9, 32, 
	-128, -1, 9, 126, 9, 59, 
	9, 126, 9, 126, 9, 
	126, 9, 126, 9, 126, 
	0, 0, 0
]

class << self
	attr_accessor :_key_spans
	private :_key_spans, :_key_spans=
end
self._key_spans = [
	0, 94, 94, 94, 118, 1, 24, 94, 
	118, 32, 1, 24, 127, 127, 1, 24, 
	1, 24, 118, 118, 1, 24, 118, 128, 
	32, 1, 24, 118, 127, 127, 1, 24, 
	128, 118, 51, 118, 118, 118, 118, 118, 
	0
]

class << self
	attr_accessor :_index_offsets
	private :_index_offsets, :_index_offsets=
end
self._index_offsets = [
	0, 0, 95, 190, 285, 404, 406, 431, 
	526, 645, 678, 680, 705, 833, 961, 963, 
	988, 990, 1015, 1134, 1253, 1255, 1280, 1399, 
	1528, 1561, 1563, 1588, 1707, 1835, 1963, 1965, 
	1990, 2119, 2238, 2290, 2409, 2528, 2647, 2766, 
	2885
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
	11, 11, 11, 11, 11, 1, 13, 1, 
	1, 1, 14, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 13, 15, 16, 
	15, 15, 15, 15, 15, 17, 1, 15, 
	15, 15, 15, 15, 1, 15, 15, 15, 
	15, 15, 15, 15, 15, 15, 15, 1, 
	1, 1, 15, 1, 1, 1, 15, 15, 
	15, 15, 15, 15, 15, 15, 15, 15, 
	15, 15, 15, 15, 15, 15, 15, 15, 
	15, 15, 15, 15, 15, 15, 15, 15, 
	1, 1, 1, 15, 15, 15, 15, 15, 
	15, 15, 15, 15, 15, 15, 15, 15, 
	15, 15, 15, 15, 15, 15, 15, 15, 
	15, 15, 15, 15, 15, 15, 15, 15, 
	15, 15, 15, 15, 1, 18, 1, 1, 
	1, 19, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 18, 1, 20, 1, 
	1, 1, 1, 1, 21, 1, 22, 1, 
	18, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 18, 
	1, 23, 23, 23, 23, 23, 23, 23, 
	23, 23, 1, 23, 23, 24, 23, 23, 
	23, 23, 23, 23, 23, 23, 23, 23, 
	23, 23, 23, 23, 23, 23, 23, 23, 
	23, 23, 25, 23, 23, 23, 23, 23, 
	23, 23, 23, 23, 23, 23, 23, 23, 
	23, 23, 23, 23, 23, 23, 23, 23, 
	23, 23, 23, 23, 23, 23, 23, 23, 
	23, 23, 23, 23, 23, 23, 23, 23, 
	23, 23, 23, 23, 23, 23, 23, 23, 
	23, 23, 23, 23, 23, 23, 23, 23, 
	23, 23, 23, 23, 26, 23, 23, 23, 
	23, 23, 23, 23, 23, 23, 23, 23, 
	23, 23, 23, 23, 23, 23, 23, 23, 
	23, 23, 23, 23, 23, 23, 23, 23, 
	23, 23, 23, 23, 23, 23, 23, 23, 
	1, 27, 27, 27, 27, 27, 27, 27, 
	27, 27, 1, 27, 27, 28, 27, 27, 
	27, 27, 27, 27, 27, 27, 27, 27, 
	27, 27, 27, 27, 27, 27, 27, 27, 
	27, 27, 29, 27, 27, 27, 27, 27, 
	27, 27, 27, 27, 27, 27, 27, 27, 
	27, 27, 27, 27, 27, 27, 27, 27, 
	27, 27, 27, 27, 27, 27, 27, 27, 
	27, 27, 27, 27, 27, 27, 27, 27, 
	27, 27, 27, 27, 27, 27, 27, 27, 
	27, 27, 27, 27, 27, 27, 27, 27, 
	27, 27, 27, 27, 30, 27, 27, 27, 
	27, 27, 27, 27, 27, 27, 27, 27, 
	27, 27, 27, 27, 27, 27, 27, 27, 
	27, 27, 27, 27, 27, 27, 27, 27, 
	27, 27, 27, 27, 27, 27, 27, 27, 
	1, 31, 1, 27, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 27, 1, 32, 1, 33, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 33, 1, 34, 
	1, 1, 1, 35, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 34, 7, 
	7, 7, 7, 7, 7, 7, 36, 1, 
	7, 7, 7, 7, 7, 1, 7, 7, 
	7, 7, 7, 7, 7, 7, 7, 7, 
	1, 9, 1, 1, 1, 1, 1, 7, 
	7, 7, 7, 7, 7, 7, 7, 7, 
	7, 7, 7, 7, 7, 7, 7, 7, 
	7, 7, 7, 7, 7, 7, 7, 7, 
	7, 1, 1, 1, 7, 7, 7, 7, 
	7, 7, 7, 7, 7, 7, 7, 7, 
	7, 7, 7, 7, 7, 7, 7, 7, 
	7, 7, 7, 7, 7, 7, 7, 7, 
	7, 7, 7, 7, 7, 1, 34, 1, 
	1, 1, 35, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 34, 7, 7, 
	7, 7, 7, 7, 7, 36, 1, 7, 
	7, 7, 7, 7, 1, 7, 7, 7, 
	7, 7, 7, 7, 7, 7, 7, 1, 
	1, 1, 1, 1, 1, 1, 7, 7, 
	7, 7, 7, 7, 7, 7, 7, 7, 
	7, 7, 7, 7, 7, 7, 7, 7, 
	7, 7, 7, 7, 7, 7, 7, 7, 
	1, 1, 1, 7, 7, 7, 7, 7, 
	7, 7, 7, 7, 7, 7, 7, 7, 
	7, 7, 7, 7, 7, 7, 7, 7, 
	7, 7, 7, 7, 7, 7, 7, 7, 
	7, 7, 7, 7, 1, 37, 1, 34, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 34, 1, 
	38, 1, 1, 1, 39, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 38, 
	40, 40, 40, 40, 40, 40, 40, 41, 
	1, 40, 40, 40, 40, 40, 1, 40, 
	40, 40, 40, 40, 40, 40, 40, 40, 
	40, 1, 1, 1, 1, 1, 1, 1, 
	40, 40, 40, 40, 40, 40, 40, 40, 
	40, 40, 40, 40, 40, 40, 40, 40, 
	40, 40, 40, 40, 40, 40, 40, 40, 
	40, 40, 1, 1, 1, 40, 40, 40, 
	40, 40, 40, 40, 40, 40, 40, 40, 
	40, 40, 40, 40, 40, 40, 40, 40, 
	40, 40, 40, 40, 40, 40, 40, 40, 
	40, 40, 40, 40, 40, 40, 1, 27, 
	27, 27, 27, 27, 27, 27, 27, 27, 
	27, 27, 27, 27, 27, 27, 27, 27, 
	27, 27, 27, 27, 27, 27, 27, 27, 
	27, 27, 27, 27, 27, 27, 27, 27, 
	27, 27, 27, 27, 27, 27, 27, 27, 
	27, 27, 27, 27, 27, 27, 27, 27, 
	27, 27, 27, 27, 27, 27, 27, 27, 
	27, 27, 27, 27, 27, 27, 27, 27, 
	27, 27, 27, 27, 27, 27, 27, 27, 
	27, 27, 27, 27, 27, 27, 27, 27, 
	27, 27, 27, 27, 27, 27, 27, 27, 
	27, 27, 27, 27, 27, 27, 27, 27, 
	27, 27, 27, 27, 27, 27, 27, 27, 
	27, 27, 27, 27, 27, 27, 27, 27, 
	27, 27, 27, 27, 27, 27, 27, 27, 
	27, 27, 27, 27, 27, 27, 27, 1, 
	42, 1, 1, 1, 43, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 42, 
	1, 44, 1, 1, 1, 1, 1, 45, 
	1, 46, 1, 47, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 47, 1, 48, 1, 1, 1, 
	49, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 48, 40, 40, 40, 40, 
	40, 40, 40, 50, 1, 40, 40, 40, 
	40, 40, 1, 40, 40, 40, 40, 40, 
	40, 40, 40, 40, 40, 1, 51, 1, 
	1, 1, 1, 1, 40, 40, 40, 40, 
	40, 40, 40, 40, 40, 40, 40, 40, 
	40, 40, 40, 40, 40, 40, 40, 40, 
	40, 40, 40, 40, 40, 40, 1, 1, 
	1, 40, 40, 40, 40, 40, 40, 40, 
	40, 40, 40, 40, 40, 40, 40, 40, 
	40, 40, 40, 40, 40, 40, 40, 40, 
	40, 40, 40, 40, 40, 40, 40, 40, 
	40, 40, 1, 52, 52, 52, 52, 52, 
	52, 52, 52, 52, 1, 52, 52, 53, 
	52, 52, 52, 52, 52, 52, 52, 52, 
	52, 52, 52, 52, 52, 52, 52, 52, 
	52, 52, 52, 52, 52, 52, 52, 52, 
	52, 52, 54, 55, 52, 52, 52, 52, 
	52, 52, 52, 52, 52, 52, 52, 52, 
	52, 52, 52, 52, 52, 52, 52, 52, 
	52, 52, 52, 52, 52, 52, 52, 52, 
	52, 52, 52, 52, 52, 52, 52, 52, 
	52, 52, 52, 52, 52, 52, 52, 52, 
	52, 52, 52, 52, 52, 52, 56, 52, 
	52, 52, 52, 52, 52, 52, 52, 52, 
	52, 52, 52, 52, 52, 52, 52, 52, 
	52, 52, 52, 52, 52, 52, 52, 52, 
	52, 52, 52, 52, 52, 52, 52, 52, 
	52, 52, 1, 57, 57, 57, 57, 57, 
	57, 57, 57, 57, 1, 57, 57, 58, 
	57, 57, 57, 57, 57, 57, 57, 57, 
	57, 57, 57, 57, 57, 57, 57, 57, 
	57, 57, 57, 57, 57, 57, 57, 57, 
	57, 57, 59, 60, 57, 57, 57, 57, 
	57, 57, 57, 57, 57, 57, 57, 57, 
	57, 57, 57, 57, 57, 57, 57, 57, 
	57, 57, 57, 57, 57, 57, 57, 57, 
	57, 57, 57, 57, 57, 57, 57, 57, 
	57, 57, 57, 57, 57, 57, 57, 57, 
	57, 57, 57, 57, 57, 57, 61, 57, 
	57, 57, 57, 57, 57, 57, 57, 57, 
	57, 57, 57, 57, 57, 57, 57, 57, 
	57, 57, 57, 57, 57, 57, 57, 57, 
	57, 57, 57, 57, 57, 57, 57, 57, 
	57, 57, 1, 62, 1, 57, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 57, 1, 1, 1, 
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
	1, 1, 1, 1, 1, 1, 57, 63, 
	1, 1, 1, 64, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 63, 65, 
	65, 65, 65, 65, 65, 65, 66, 1, 
	65, 65, 65, 65, 65, 1, 65, 65, 
	65, 65, 65, 65, 65, 65, 65, 65, 
	1, 67, 1, 1, 1, 1, 1, 65, 
	65, 65, 65, 65, 65, 65, 65, 65, 
	65, 65, 65, 65, 65, 65, 65, 65, 
	65, 65, 65, 65, 65, 65, 65, 65, 
	65, 1, 1, 1, 65, 65, 65, 65, 
	65, 65, 65, 65, 65, 65, 65, 65, 
	65, 65, 65, 65, 65, 65, 65, 65, 
	65, 65, 65, 65, 65, 65, 65, 65, 
	65, 65, 65, 65, 65, 1, 68, 1, 
	1, 1, 69, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 68, 1, 1, 
	1, 1, 1, 1, 1, 70, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	71, 1, 68, 1, 1, 1, 69, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 68, 7, 7, 7, 7, 7, 7, 
	7, 70, 1, 7, 7, 7, 7, 7, 
	1, 7, 7, 7, 7, 7, 7, 7, 
	7, 7, 7, 1, 71, 1, 1, 1, 
	1, 1, 7, 7, 7, 7, 7, 7, 
	7, 7, 7, 7, 7, 7, 7, 7, 
	7, 7, 7, 7, 7, 7, 7, 7, 
	7, 7, 7, 7, 1, 1, 1, 7, 
	7, 7, 7, 7, 7, 7, 7, 7, 
	7, 7, 7, 7, 7, 7, 7, 7, 
	7, 7, 7, 7, 7, 7, 7, 7, 
	7, 7, 7, 7, 7, 7, 7, 7, 
	1, 72, 1, 1, 1, 73, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	72, 40, 40, 40, 40, 40, 40, 40, 
	74, 1, 40, 40, 40, 40, 40, 1, 
	40, 40, 40, 40, 40, 40, 40, 40, 
	40, 40, 1, 75, 1, 1, 1, 1, 
	1, 40, 40, 40, 40, 40, 40, 40, 
	40, 40, 40, 40, 40, 40, 40, 40, 
	40, 40, 40, 40, 40, 40, 40, 40, 
	40, 40, 40, 1, 1, 1, 40, 40, 
	40, 40, 40, 40, 40, 40, 40, 40, 
	40, 40, 40, 40, 40, 40, 40, 40, 
	40, 40, 40, 40, 40, 40, 40, 40, 
	40, 40, 40, 40, 40, 40, 40, 1, 
	76, 1, 1, 1, 77, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 76, 
	78, 1, 78, 78, 78, 78, 78, 79, 
	1, 78, 78, 78, 78, 78, 1, 78, 
	78, 78, 78, 78, 78, 78, 78, 78, 
	78, 1, 71, 1, 78, 1, 1, 1, 
	78, 78, 78, 78, 78, 78, 78, 78, 
	78, 78, 78, 78, 78, 78, 78, 78, 
	78, 78, 78, 78, 78, 78, 78, 78, 
	78, 78, 1, 1, 1, 78, 78, 78, 
	78, 78, 78, 78, 78, 78, 78, 78, 
	78, 78, 78, 78, 78, 78, 78, 78, 
	78, 78, 78, 78, 78, 78, 78, 78, 
	78, 78, 78, 78, 78, 78, 1, 47, 
	1, 1, 1, 80, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 47, 7, 
	7, 7, 7, 7, 7, 7, 81, 1, 
	7, 7, 7, 7, 7, 1, 7, 7, 
	7, 7, 7, 7, 7, 7, 7, 7, 
	1, 9, 1, 1, 1, 1, 1, 7, 
	7, 7, 7, 7, 7, 7, 7, 7, 
	7, 7, 7, 7, 7, 7, 7, 7, 
	7, 7, 7, 7, 7, 7, 7, 7, 
	7, 1, 1, 1, 7, 7, 7, 7, 
	7, 7, 7, 7, 7, 7, 7, 7, 
	7, 7, 7, 7, 7, 7, 7, 7, 
	7, 7, 7, 7, 7, 7, 7, 7, 
	7, 7, 7, 7, 7, 1, 82, 1, 
	1, 1, 83, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 82, 40, 40, 
	40, 40, 40, 40, 40, 84, 1, 40, 
	40, 40, 40, 40, 1, 40, 40, 40, 
	40, 40, 40, 40, 40, 40, 40, 1, 
	51, 1, 1, 1, 1, 1, 40, 40, 
	40, 40, 40, 40, 40, 40, 40, 40, 
	40, 40, 40, 40, 40, 40, 40, 40, 
	40, 40, 40, 40, 40, 40, 40, 40, 
	1, 1, 1, 40, 40, 40, 40, 40, 
	40, 40, 40, 40, 40, 40, 40, 40, 
	40, 40, 40, 40, 40, 40, 40, 40, 
	40, 40, 40, 40, 40, 40, 40, 40, 
	40, 40, 40, 40, 1, 1, 0
]

class << self
	attr_accessor :_trans_targs
	private :_trans_targs, :_trans_targs=
end
self._trans_targs = [
	2, 0, 2, 3, 33, 4, 5, 7, 
	27, 18, 6, 7, 8, 9, 10, 37, 
	12, 24, 9, 10, 12, 24, 11, 13, 
	14, 34, 23, 13, 14, 34, 23, 15, 
	17, 35, 19, 20, 22, 21, 19, 20, 
	7, 22, 9, 10, 12, 24, 26, 38, 
	4, 5, 27, 18, 29, 30, 29, 40, 
	32, 29, 30, 29, 40, 32, 31, 4, 
	5, 33, 27, 18, 35, 16, 36, 18, 
	35, 16, 36, 18, 38, 25, 37, 39, 
	25, 39, 38, 25, 39
]

class << self
	attr_accessor :_trans_actions
	private :_trans_actions, :_trans_actions=
end
self._trans_actions = [
	1, 0, 0, 2, 3, 0, 0, 4, 
	5, 0, 0, 0, 6, 7, 7, 7, 
	7, 8, 0, 0, 0, 5, 0, 9, 
	9, 10, 9, 0, 0, 11, 0, 0, 
	0, 0, 0, 0, 5, 0, 12, 12, 
	13, 14, 12, 12, 12, 14, 0, 0, 
	12, 12, 14, 12, 15, 15, 16, 17, 
	15, 0, 0, 5, 18, 0, 0, 19, 
	19, 0, 20, 19, 21, 21, 22, 21, 
	23, 23, 24, 23, 21, 21, 0, 25, 
	0, 5, 12, 12, 14
]

class << self
	attr_accessor :_eof_actions
	private :_eof_actions, :_eof_actions=
end
self._eof_actions = [
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 19, 21, 21, 23, 21, 0, 12, 
	0
]

class << self
	attr_accessor :start
end
self.start = 1;
class << self
	attr_accessor :first_final
end
self.first_final = 33;
class << self
	attr_accessor :error
end
self.error = 0;

class << self
	attr_accessor :en_comment_tail
end
self.en_comment_tail = 28;
class << self
	attr_accessor :en_main
end
self.en_main = 1;



    def self.parse(data)
      return ContentTypeStruct.new('text', 'plain', []) if Mail::Utilities.blank?(data)
      content_type = ContentTypeStruct.new(nil, nil, [])

      # Parser state
      main_type_s = sub_type_s = param_attr_s = param_attr = nil
      qstr_s = qstr = param_val_s = nil

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
 main_type_s = p 		end
	when 2 then
		begin
 content_type.main_type = data[main_type_s..(p-1)].downcase 		end
	when 3 then
		begin
 sub_type_s = p 		end
	when 19 then
		begin
 content_type.sub_type = data[sub_type_s..(p-1)].downcase 		end
	when 4 then
		begin
 param_attr_s = p 		end
	when 6 then
		begin
 param_attr = data[param_attr_s..(p-1)] 		end
	when 9 then
		begin
 qstr_s = p 		end
	when 11 then
		begin
 qstr = data[qstr_s..(p-1)] 		end
	when 7 then
		begin
 param_val_s = p 		end
	when 21 then
		begin

    if param_attr.nil?
      raise Mail::Field::ParseError.new(Mail::ContentTypeElement, data, "no attribute for value")
    end

    # Use quoted s value if one exists, otherwise use parameter value
    value = qstr || data[param_val_s..(p-1)]

    content_type.parameters << { param_attr => value }
    param_attr = nil
    qstr = nil
  		end
	when 12 then
		begin
 		end
	when 15 then
		begin
 		end
	when 5 then
		begin
 	begin
		stack[top] = cs
		top+= 1
		cs = 28
		_goto_level = _again
		next
	end
 		end
	when 18 then
		begin
 	begin
		top -= 1
		cs = stack[top]
		_goto_level = _again
		next
	end
 		end
	when 20 then
		begin
 content_type.sub_type = data[sub_type_s..(p-1)].downcase 		end
		begin
 	begin
		stack[top] = cs
		top+= 1
		cs = 28
		_goto_level = _again
		next
	end
 		end
	when 10 then
		begin
 qstr_s = p 		end
		begin
 qstr = data[qstr_s..(p-1)] 		end
	when 8 then
		begin
 param_val_s = p 		end
		begin
 	begin
		stack[top] = cs
		top+= 1
		cs = 28
		_goto_level = _again
		next
	end
 		end
	when 25 then
		begin

    if param_attr.nil?
      raise Mail::Field::ParseError.new(Mail::ContentTypeElement, data, "no attribute for value")
    end

    # Use quoted s value if one exists, otherwise use parameter value
    value = qstr || data[param_val_s..(p-1)]

    content_type.parameters << { param_attr => value }
    param_attr = nil
    qstr = nil
  		end
		begin
 	begin
		stack[top] = cs
		top+= 1
		cs = 28
		_goto_level = _again
		next
	end
 		end
	when 13 then
		begin
 		end
		begin
 param_attr_s = p 		end
	when 23 then
		begin
 		end
		begin

    if param_attr.nil?
      raise Mail::Field::ParseError.new(Mail::ContentTypeElement, data, "no attribute for value")
    end

    # Use quoted s value if one exists, otherwise use parameter value
    value = qstr || data[param_val_s..(p-1)]

    content_type.parameters << { param_attr => value }
    param_attr = nil
    qstr = nil
  		end
	when 14 then
		begin
 		end
		begin
 	begin
		stack[top] = cs
		top+= 1
		cs = 28
		_goto_level = _again
		next
	end
 		end
	when 16 then
		begin
 		end
		begin
 	begin
		stack[top] = cs
		top+= 1
		cs = 28
		_goto_level = _again
		next
	end
 		end
	when 17 then
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
	when 22 then
		begin
 	begin
		stack[top] = cs
		top+= 1
		cs = 28
		_goto_level = _again
		next
	end
 		end
		begin

    if param_attr.nil?
      raise Mail::Field::ParseError.new(Mail::ContentTypeElement, data, "no attribute for value")
    end

    # Use quoted s value if one exists, otherwise use parameter value
    value = qstr || data[param_val_s..(p-1)]

    content_type.parameters << { param_attr => value }
    param_attr = nil
    qstr = nil
  		end
	when 24 then
		begin
 		end
		begin
 	begin
		stack[top] = cs
		top+= 1
		cs = 28
		_goto_level = _again
		next
	end
 		end
		begin

    if param_attr.nil?
      raise Mail::Field::ParseError.new(Mail::ContentTypeElement, data, "no attribute for value")
    end

    # Use quoted s value if one exists, otherwise use parameter value
    value = qstr || data[param_val_s..(p-1)]

    content_type.parameters << { param_attr => value }
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
	when 19 then
		begin
 content_type.sub_type = data[sub_type_s..(p-1)].downcase 		end
	when 21 then
		begin

    if param_attr.nil?
      raise Mail::Field::ParseError.new(Mail::ContentTypeElement, data, "no attribute for value")
    end

    # Use quoted s value if one exists, otherwise use parameter value
    value = qstr || data[param_val_s..(p-1)]

    content_type.parameters << { param_attr => value }
    param_attr = nil
    qstr = nil
  		end
	when 12 then
		begin
 		end
	when 23 then
		begin
 		end
		begin

    if param_attr.nil?
      raise Mail::Field::ParseError.new(Mail::ContentTypeElement, data, "no attribute for value")
    end

    # Use quoted s value if one exists, otherwise use parameter value
    value = qstr || data[param_val_s..(p-1)]

    content_type.parameters << { param_attr => value }
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


      if p != eof || cs < 33
        raise Mail::Field::ParseError.new(Mail::ContentTypeElement, data, "Only able to parse up to #{data[0..p]}")
      end

      content_type
    end
  end
end
