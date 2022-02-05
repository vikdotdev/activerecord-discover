require 'fast'
require 'unparser'
require 'rouge'
require 'colorize'

require "activerecord_discover/railtie"
require 'activerecord_discover/constants'
require 'activerecord_discover/callback_permutator'
require 'activerecord_discover/association_list'
require 'activerecord_discover/validation_list'
require 'activerecord_discover/callback_list'

require 'activerecord_discover/ast_callback'
require 'activerecord_discover/callback_source_location'

require 'activerecord_discover/base_formatter'
require 'activerecord_discover/with_highlighting_formatter'
require 'activerecord_discover/with_line_numbers_formatter'

require 'activerecord_discover/base_printer'

require 'activerecord_discover/console_methods'
