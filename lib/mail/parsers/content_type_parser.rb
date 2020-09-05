# frozen_string_literal: true
require "mail/utilities"
require "mail/parser_tools"

begin
  original_verbose, $VERBOSE = $VERBOSE, nil

  module Mail::Parsers
    module ContentTypeParser
      extend Mail::ParserTools

      ContentTypeStruct = Struct.new(:main_type, :sub_type, :parameters, :error)

      class << self
        attr_accessor :_trans_keys
        private :_trans_keys, :_trans_keys=
      end
      self._trans_keys = ::Ragel::Array.new("0 0 33 126 33 126 33 126 9 126 10 10 9 32 33 126 9 126 9 40 10 10 9 32 1 244 1 244 10 10 9 32 10 10 9 32 9 126 9 126 10 10 9 32 9 126 0 244 128 191 160 191 128 191 128 159 144 191 128 191 128 143 9 40 10 10 9 32 9 126 1 244 1 244 10 10 9 32 0 244 128 191 160 191 128 191 128 159 144 191 128 191 128 143 9 126 9 59 9 126 9 126 9 126 9 126 9 126 0 0 0", 111)

      class << self
        attr_accessor :_key_spans
        private :_key_spans, :_key_spans=
      end
      self._key_spans = ::Ragel::Array.new("0 94 94 94 118 1 24 94 118 32 1 24 244 244 1 24 1 24 118 118 1 24 118 245 64 32 64 32 48 64 16 32 1 24 118 244 244 1 24 245 64 32 64 32 48 64 16 118 51 118 118 118 118 118 0", 55)

      class << self
        attr_accessor :_index_offsets
        private :_index_offsets, :_index_offsets=
      end
      self._index_offsets = ::Ragel::Array.new("0 0 95 190 285 404 406 431 526 645 678 680 705 950 1195 1197 1222 1224 1249 1368 1487 1489 1514 1633 1879 1944 1977 2042 2075 2124 2189 2206 2239 2241 2266 2385 2630 2875 2877 2902 3148 3213 3246 3311 3344 3393 3458 3475 3594 3646 3765 3884 4003 4122 4241", 55)

      class << self
        attr_accessor :_indicies
        private :_indicies, :_indicies=
      end
      self._indicies = ::Ragel::Array.new("0 0 0 0 0 0 0 1 1 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 2 2 2 2 2 2 2 1 1 2 2 2 2 2 3 2 2 2 2 2 2 2 2 2 2 1 1 1 1 1 1 1 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 1 1 1 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 1 4 4 4 4 4 4 4 1 1 4 4 4 4 4 1 4 4 4 4 4 4 4 4 4 4 1 1 1 1 1 1 1 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 1 1 1 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 1 5 1 1 1 6 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 5 7 7 7 7 7 7 7 8 1 7 7 7 7 7 1 7 7 7 7 7 7 7 7 7 7 1 9 1 1 1 1 1 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 1 1 1 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 1 10 1 5 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 5 1 11 11 11 11 11 11 11 1 1 11 11 11 11 11 1 11 11 11 11 11 11 11 11 11 11 1 1 1 12 1 1 1 11 11 11 11 11 11 11 11 11 11 11 11 11 11 11 11 11 11 11 11 11 11 11 11 11 11 1 1 1 11 11 11 11 11 11 11 11 11 11 11 11 11 11 11 11 11 11 11 11 11 11 11 11 11 11 11 11 11 11 11 11 11 1 13 1 1 1 14 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 13 15 16 15 15 15 15 15 17 1 15 15 15 15 15 1 15 15 15 15 15 15 15 15 15 15 1 1 1 15 1 1 1 15 15 15 15 15 15 15 15 15 15 15 15 15 15 15 15 15 15 15 15 15 15 15 15 15 15 1 1 1 15 15 15 15 15 15 15 15 15 15 15 15 15 15 15 15 15 15 15 15 15 15 15 15 15 15 15 15 15 15 15 15 15 1 18 1 1 1 19 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 18 1 20 1 1 1 1 1 21 1 22 1 18 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 18 1 23 23 23 23 23 23 23 23 23 1 23 23 24 23 23 23 23 23 23 23 23 23 23 23 23 23 23 23 23 23 23 23 23 25 23 23 23 23 23 23 23 23 23 23 23 23 23 23 23 23 23 23 23 23 23 23 23 23 23 23 23 23 23 23 23 23 23 23 23 23 23 23 23 23 23 23 23 23 23 23 23 23 23 23 23 23 23 23 23 23 23 26 23 23 23 23 23 23 23 23 23 23 23 23 23 23 23 23 23 23 23 23 23 23 23 23 23 23 23 23 23 23 23 23 23 23 23 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 27 27 27 27 27 27 27 27 27 27 27 27 27 27 27 27 27 27 27 27 27 27 27 27 27 27 27 27 27 27 28 29 29 29 29 29 29 29 29 29 29 29 29 30 29 29 31 32 32 32 33 1 34 34 34 34 34 34 34 34 34 1 34 34 35 34 34 34 34 34 34 34 34 34 34 34 34 34 34 34 34 34 34 34 34 36 34 34 34 34 34 34 34 34 34 34 34 34 34 34 34 34 34 34 34 34 34 34 34 34 34 34 34 34 34 34 34 34 34 34 34 34 34 34 34 34 34 34 34 34 34 34 34 34 34 34 34 34 34 34 34 34 34 37 34 34 34 34 34 34 34 34 34 34 34 34 34 34 34 34 34 34 34 34 34 34 34 34 34 34 34 34 34 34 34 34 34 34 34 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 38 38 38 38 38 38 38 38 38 38 38 38 38 38 38 38 38 38 38 38 38 38 38 38 38 38 38 38 38 38 39 40 40 40 40 40 40 40 40 40 40 40 40 41 40 40 42 43 43 43 44 1 45 1 34 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 34 1 46 1 47 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 47 1 48 1 1 1 49 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 48 7 7 7 7 7 7 7 50 1 7 7 7 7 7 1 7 7 7 7 7 7 7 7 7 7 1 9 1 1 1 1 1 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 1 1 1 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 1 48 1 1 1 49 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 48 7 7 7 7 7 7 7 50 1 7 7 7 7 7 1 7 7 7 7 7 7 7 7 7 7 1 1 1 1 1 1 1 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 1 1 1 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 1 51 1 48 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 48 1 52 1 1 1 53 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 52 54 54 54 54 54 54 54 55 1 54 54 54 54 54 1 54 54 54 54 54 54 54 54 54 54 1 1 1 1 1 1 1 54 54 54 54 54 54 54 54 54 54 54 54 54 54 54 54 54 54 54 54 54 54 54 54 54 54 1 1 1 54 54 54 54 54 54 54 54 54 54 54 54 54 54 54 54 54 54 54 54 54 54 54 54 54 54 54 54 54 54 54 54 54 1 34 34 34 34 34 34 34 34 34 34 34 34 34 34 34 34 34 34 34 34 34 34 34 34 34 34 34 34 34 34 34 34 34 34 34 34 34 34 34 34 34 34 34 34 34 34 34 34 34 34 34 34 34 34 34 34 34 34 34 34 34 34 34 34 34 34 34 34 34 34 34 34 34 34 34 34 34 34 34 34 34 34 34 34 34 34 34 34 34 34 34 34 34 34 34 34 34 34 34 34 34 34 34 34 34 34 34 34 34 34 34 34 34 34 34 34 34 34 34 34 34 34 34 34 34 34 34 34 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 38 38 38 38 38 38 38 38 38 38 38 38 38 38 38 38 38 38 38 38 38 38 38 38 38 38 38 38 38 38 39 40 40 40 40 40 40 40 40 40 40 40 40 41 40 40 42 43 43 43 44 1 34 34 34 34 34 34 34 34 34 34 34 34 34 34 34 34 34 34 34 34 34 34 34 34 34 34 34 34 34 34 34 34 34 34 34 34 34 34 34 34 34 34 34 34 34 34 34 34 34 34 34 34 34 34 34 34 34 34 34 34 34 34 34 34 1 38 38 38 38 38 38 38 38 38 38 38 38 38 38 38 38 38 38 38 38 38 38 38 38 38 38 38 38 38 38 38 38 1 38 38 38 38 38 38 38 38 38 38 38 38 38 38 38 38 38 38 38 38 38 38 38 38 38 38 38 38 38 38 38 38 38 38 38 38 38 38 38 38 38 38 38 38 38 38 38 38 38 38 38 38 38 38 38 38 38 38 38 38 38 38 38 38 1 38 38 38 38 38 38 38 38 38 38 38 38 38 38 38 38 38 38 38 38 38 38 38 38 38 38 38 38 38 38 38 38 1 40 40 40 40 40 40 40 40 40 40 40 40 40 40 40 40 40 40 40 40 40 40 40 40 40 40 40 40 40 40 40 40 40 40 40 40 40 40 40 40 40 40 40 40 40 40 40 40 1 40 40 40 40 40 40 40 40 40 40 40 40 40 40 40 40 40 40 40 40 40 40 40 40 40 40 40 40 40 40 40 40 40 40 40 40 40 40 40 40 40 40 40 40 40 40 40 40 40 40 40 40 40 40 40 40 40 40 40 40 40 40 40 40 1 40 40 40 40 40 40 40 40 40 40 40 40 40 40 40 40 1 56 1 1 1 57 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 56 1 58 1 1 1 1 1 59 1 60 1 61 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 61 1 62 1 1 1 63 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 62 54 54 54 54 54 54 54 64 1 54 54 54 54 54 1 54 54 54 54 54 54 54 54 54 54 1 65 1 1 1 1 1 54 54 54 54 54 54 54 54 54 54 54 54 54 54 54 54 54 54 54 54 54 54 54 54 54 54 1 1 1 54 54 54 54 54 54 54 54 54 54 54 54 54 54 54 54 54 54 54 54 54 54 54 54 54 54 54 54 54 54 54 54 54 1 66 66 66 66 66 66 66 66 66 1 66 66 67 66 66 66 66 66 66 66 66 66 66 66 66 66 66 66 66 66 66 66 66 66 66 66 66 66 66 68 69 66 66 66 66 66 66 66 66 66 66 66 66 66 66 66 66 66 66 66 66 66 66 66 66 66 66 66 66 66 66 66 66 66 66 66 66 66 66 66 66 66 66 66 66 66 66 66 66 66 66 70 66 66 66 66 66 66 66 66 66 66 66 66 66 66 66 66 66 66 66 66 66 66 66 66 66 66 66 66 66 66 66 66 66 66 66 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 71 71 71 71 71 71 71 71 71 71 71 71 71 71 71 71 71 71 71 71 71 71 71 71 71 71 71 71 71 71 72 73 73 73 73 73 73 73 73 73 73 73 73 74 73 73 75 76 76 76 77 1 78 78 78 78 78 78 78 78 78 1 78 78 79 78 78 78 78 78 78 78 78 78 78 78 78 78 78 78 78 78 78 78 78 78 78 78 78 78 78 80 81 78 78 78 78 78 78 78 78 78 78 78 78 78 78 78 78 78 78 78 78 78 78 78 78 78 78 78 78 78 78 78 78 78 78 78 78 78 78 78 78 78 78 78 78 78 78 78 78 78 78 82 78 78 78 78 78 78 78 78 78 78 78 78 78 78 78 78 78 78 78 78 78 78 78 78 78 78 78 78 78 78 78 78 78 78 78 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 83 83 83 83 83 83 83 83 83 83 83 83 83 83 83 83 83 83 83 83 83 83 83 83 83 83 83 83 83 83 84 85 85 85 85 85 85 85 85 85 85 85 85 86 85 85 87 88 88 88 89 1 90 1 78 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 78 1 78 78 78 78 78 78 78 78 78 78 78 78 78 78 78 78 78 78 78 78 78 78 78 78 78 78 78 78 78 78 78 78 78 78 78 78 78 78 78 78 78 78 78 78 78 78 78 78 78 78 78 78 78 78 78 78 78 78 78 78 78 78 78 78 78 78 78 78 78 78 78 78 78 78 78 78 78 78 78 78 78 78 78 78 78 78 78 78 78 78 78 78 78 78 78 78 78 78 78 78 78 78 78 78 78 78 78 78 78 78 78 78 78 78 78 78 78 78 78 78 78 78 78 78 78 78 78 78 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 83 83 83 83 83 83 83 83 83 83 83 83 83 83 83 83 83 83 83 83 83 83 83 83 83 83 83 83 83 83 84 85 85 85 85 85 85 85 85 85 85 85 85 86 85 85 87 88 88 88 89 1 78 78 78 78 78 78 78 78 78 78 78 78 78 78 78 78 78 78 78 78 78 78 78 78 78 78 78 78 78 78 78 78 78 78 78 78 78 78 78 78 78 78 78 78 78 78 78 78 78 78 78 78 78 78 78 78 78 78 78 78 78 78 78 78 1 83 83 83 83 83 83 83 83 83 83 83 83 83 83 83 83 83 83 83 83 83 83 83 83 83 83 83 83 83 83 83 83 1 83 83 83 83 83 83 83 83 83 83 83 83 83 83 83 83 83 83 83 83 83 83 83 83 83 83 83 83 83 83 83 83 83 83 83 83 83 83 83 83 83 83 83 83 83 83 83 83 83 83 83 83 83 83 83 83 83 83 83 83 83 83 83 83 1 83 83 83 83 83 83 83 83 83 83 83 83 83 83 83 83 83 83 83 83 83 83 83 83 83 83 83 83 83 83 83 83 1 85 85 85 85 85 85 85 85 85 85 85 85 85 85 85 85 85 85 85 85 85 85 85 85 85 85 85 85 85 85 85 85 85 85 85 85 85 85 85 85 85 85 85 85 85 85 85 85 1 85 85 85 85 85 85 85 85 85 85 85 85 85 85 85 85 85 85 85 85 85 85 85 85 85 85 85 85 85 85 85 85 85 85 85 85 85 85 85 85 85 85 85 85 85 85 85 85 85 85 85 85 85 85 85 85 85 85 85 85 85 85 85 85 1 85 85 85 85 85 85 85 85 85 85 85 85 85 85 85 85 1 91 1 1 1 92 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 91 93 93 93 93 93 93 93 94 1 93 93 93 93 93 1 93 93 93 93 93 93 93 93 93 93 1 95 1 1 1 1 1 93 93 93 93 93 93 93 93 93 93 93 93 93 93 93 93 93 93 93 93 93 93 93 93 93 93 1 1 1 93 93 93 93 93 93 93 93 93 93 93 93 93 93 93 93 93 93 93 93 93 93 93 93 93 93 93 93 93 93 93 93 93 1 96 1 1 1 97 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 96 1 1 1 1 1 1 1 98 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 99 1 96 1 1 1 97 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 96 7 7 7 7 7 7 7 98 1 7 7 7 7 7 1 7 7 7 7 7 7 7 7 7 7 1 99 1 1 1 1 1 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 1 1 1 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 1 100 1 1 1 101 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 100 54 54 54 54 54 54 54 102 1 54 54 54 54 54 1 54 54 54 54 54 54 54 54 54 54 1 103 1 1 1 1 1 54 54 54 54 54 54 54 54 54 54 54 54 54 54 54 54 54 54 54 54 54 54 54 54 54 54 1 1 1 54 54 54 54 54 54 54 54 54 54 54 54 54 54 54 54 54 54 54 54 54 54 54 54 54 54 54 54 54 54 54 54 54 1 104 1 1 1 105 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 104 106 1 106 106 106 106 106 107 1 106 106 106 106 106 1 106 106 106 106 106 106 106 106 106 106 1 99 1 106 1 1 1 106 106 106 106 106 106 106 106 106 106 106 106 106 106 106 106 106 106 106 106 106 106 106 106 106 106 1 1 1 106 106 106 106 106 106 106 106 106 106 106 106 106 106 106 106 106 106 106 106 106 106 106 106 106 106 106 106 106 106 106 106 106 1 61 1 1 1 108 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 61 7 7 7 7 7 7 7 109 1 7 7 7 7 7 1 7 7 7 7 7 7 7 7 7 7 1 9 1 1 1 1 1 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 1 1 1 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 1 110 1 1 1 111 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 110 54 54 54 54 54 54 54 112 1 54 54 54 54 54 1 54 54 54 54 54 54 54 54 54 54 1 65 1 1 1 1 1 54 54 54 54 54 54 54 54 54 54 54 54 54 54 54 54 54 54 54 54 54 54 54 54 54 54 1 1 1 54 54 54 54 54 54 54 54 54 54 54 54 54 54 54 54 54 54 54 54 54 54 54 54 54 54 54 54 54 54 54 54 54 1 1 0", 4243)

      class << self
        attr_accessor :_trans_targs
        private :_trans_targs, :_trans_targs=
      end
      self._trans_targs = ::Ragel::Array.new("2 0 2 3 47 4 5 7 34 18 6 7 8 9 10 51 12 31 9 10 12 31 11 13 14 48 23 24 25 26 27 28 29 30 13 14 48 23 24 25 26 27 28 29 30 15 17 49 19 20 22 21 19 20 7 22 9 10 12 31 33 52 4 5 34 18 36 37 36 54 39 40 41 42 43 44 45 46 36 37 36 54 39 40 41 42 43 44 45 46 38 4 5 47 34 18 49 16 50 18 49 16 50 18 52 32 51 53 32 53 52 32 53", 113)

      class << self
        attr_accessor :_trans_actions
        private :_trans_actions, :_trans_actions=
      end
      self._trans_actions = ::Ragel::Array.new("1 0 0 2 3 0 0 4 5 0 0 0 6 7 7 7 7 8 0 0 0 5 0 9 9 10 9 9 9 9 9 9 9 9 0 0 11 0 0 0 0 0 0 0 0 0 0 0 0 0 5 0 12 12 13 14 12 12 12 14 0 0 12 12 14 12 15 15 16 17 15 15 15 15 15 15 15 15 0 0 5 18 0 0 0 0 0 0 0 0 0 19 19 0 20 19 21 21 22 21 23 23 24 23 21 21 0 25 0 5 12 12 14", 113)

      class << self
        attr_accessor :_eof_actions
        private :_eof_actions, :_eof_actions=
      end
      self._eof_actions = ::Ragel::Array.new("0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 19 21 21 23 21 0 12 0", 55)

      class << self
        attr_accessor :start
      end
      self.start = 1
      class << self
        attr_accessor :first_final
      end
      self.first_final = 47
      class << self
        attr_accessor :error
      end
      self.error = 0

      class << self
        attr_accessor :en_comment_tail
      end
      self.en_comment_tail = 35
      class << self
        attr_accessor :en_main
      end
      self.en_main = 1

      def self.parse(data)
        data = data.dup.force_encoding(Encoding::ASCII_8BIT) if data.respond_to?(:force_encoding)

        return ContentTypeStruct.new("text", "plain", []) if Mail::Utilities.blank?(data)
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
              _trans = if (_slen > 0 &&
                           _trans_keys[_keys] <= _wide &&
                           _wide <= _trans_keys[_keys + 1])
                  _indicies[_inds + _wide - _trans_keys[_keys]]
                else
                  _indicies[_inds + _slen]
                end
              cs = _trans_targs[_trans]
              if _trans_actions[_trans] != 0
                case _trans_actions[_trans]
                when 1
                  begin
                    main_type_s = p
                  end
                when 2
                  begin
                    content_type.main_type = chars(data, main_type_s, p - 1).downcase
                  end
                when 3
                  begin
                    sub_type_s = p
                  end
                when 19
                  begin
                    content_type.sub_type = chars(data, sub_type_s, p - 1).downcase
                  end
                when 4
                  begin
                    param_attr_s = p
                  end
                when 6
                  begin
                    param_attr = chars(data, param_attr_s, p - 1)
                  end
                when 9
                  begin
                    qstr_s = p
                  end
                when 11
                  begin
                    qstr = chars(data, qstr_s, p - 1)
                  end
                when 7
                  begin
                    param_val_s = p
                  end
                when 21
                  begin
                    if param_attr.nil?
                      raise Mail::Field::ParseError.new(Mail::ContentTypeElement, data, "no attribute for value")
                    end

                    # Use quoted s value if one exists, otherwise use parameter value
                    value = qstr || chars(data, param_val_s, p - 1)

                    content_type.parameters << { param_attr => value }
                    param_attr = nil
                    qstr = nil
                  end
                when 12
                  begin
                  end
                when 15
                  begin
                  end
                when 5
                  begin
                    begin
                      stack[top] = cs
                      top += 1
                      cs = 35
                      _goto_level = _again
                      next
                    end
                  end
                when 18
                  begin
                    begin
                      top -= 1
                      cs = stack[top]
                      _goto_level = _again
                      next
                    end
                  end
                when 20
                  begin
                    content_type.sub_type = chars(data, sub_type_s, p - 1).downcase
                  end
                  begin
                    begin
                      stack[top] = cs
                      top += 1
                      cs = 35
                      _goto_level = _again
                      next
                    end
                  end
                when 10
                  begin
                    qstr_s = p
                  end
                  begin
                    qstr = chars(data, qstr_s, p - 1)
                  end
                when 8
                  begin
                    param_val_s = p
                  end
                  begin
                    begin
                      stack[top] = cs
                      top += 1
                      cs = 35
                      _goto_level = _again
                      next
                    end
                  end
                when 25
                  begin
                    if param_attr.nil?
                      raise Mail::Field::ParseError.new(Mail::ContentTypeElement, data, "no attribute for value")
                    end

                    # Use quoted s value if one exists, otherwise use parameter value
                    value = qstr || chars(data, param_val_s, p - 1)

                    content_type.parameters << { param_attr => value }
                    param_attr = nil
                    qstr = nil
                  end
                  begin
                    begin
                      stack[top] = cs
                      top += 1
                      cs = 35
                      _goto_level = _again
                      next
                    end
                  end
                when 13
                  begin
                  end
                  begin
                    param_attr_s = p
                  end
                when 23
                  begin
                  end
                  begin
                    if param_attr.nil?
                      raise Mail::Field::ParseError.new(Mail::ContentTypeElement, data, "no attribute for value")
                    end

                    # Use quoted s value if one exists, otherwise use parameter value
                    value = qstr || chars(data, param_val_s, p - 1)

                    content_type.parameters << { param_attr => value }
                    param_attr = nil
                    qstr = nil
                  end
                when 14
                  begin
                  end
                  begin
                    begin
                      stack[top] = cs
                      top += 1
                      cs = 35
                      _goto_level = _again
                      next
                    end
                  end
                when 16
                  begin
                  end
                  begin
                    begin
                      stack[top] = cs
                      top += 1
                      cs = 35
                      _goto_level = _again
                      next
                    end
                  end
                when 17
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
                when 22
                  begin
                    begin
                      stack[top] = cs
                      top += 1
                      cs = 35
                      _goto_level = _again
                      next
                    end
                  end
                  begin
                    if param_attr.nil?
                      raise Mail::Field::ParseError.new(Mail::ContentTypeElement, data, "no attribute for value")
                    end

                    # Use quoted s value if one exists, otherwise use parameter value
                    value = qstr || chars(data, param_val_s, p - 1)

                    content_type.parameters << { param_attr => value }
                    param_attr = nil
                    qstr = nil
                  end
                when 24
                  begin
                  end
                  begin
                    begin
                      stack[top] = cs
                      top += 1
                      cs = 35
                      _goto_level = _again
                      next
                    end
                  end
                  begin
                    if param_attr.nil?
                      raise Mail::Field::ParseError.new(Mail::ContentTypeElement, data, "no attribute for value")
                    end

                    # Use quoted s value if one exists, otherwise use parameter value
                    value = qstr || chars(data, param_val_s, p - 1)

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
                when 19
                  begin
                    content_type.sub_type = chars(data, sub_type_s, p - 1).downcase
                  end
                when 21
                  begin
                    if param_attr.nil?
                      raise Mail::Field::ParseError.new(Mail::ContentTypeElement, data, "no attribute for value")
                    end

                    # Use quoted s value if one exists, otherwise use parameter value
                    value = qstr || chars(data, param_val_s, p - 1)

                    content_type.parameters << { param_attr => value }
                    param_attr = nil
                    qstr = nil
                  end
                when 12
                  begin
                  end
                when 23
                  begin
                  end
                  begin
                    if param_attr.nil?
                      raise Mail::Field::ParseError.new(Mail::ContentTypeElement, data, "no attribute for value")
                    end

                    # Use quoted s value if one exists, otherwise use parameter value
                    value = qstr || chars(data, param_val_s, p - 1)

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

        if p != eof || cs < 47
          raise Mail::Field::IncompleteParseError.new(Mail::ContentTypeElement, data, p)
        end

        content_type
      end
    end
  end
ensure
  $VERBOSE = original_verbose
end
