require 'fast'
require 'unparser'
require 'rouge'
require 'colorize'

require "activerecord_discover/railtie"
require 'activerecord_discover/constants'
require 'activerecord_discover/configuration'

require 'activerecord_discover/permutator'
require 'activerecord_discover/association_list'
require 'activerecord_discover/validation_list'
require 'activerecord_discover/callback_list'

require 'activerecord_discover/ast_callback'
require 'activerecord_discover/ast_callback_metadata'
require 'activerecord_discover/ast_method'
require 'activerecord_discover/callback_source_location'
require 'activerecord_discover/line_number_configuration'

require 'activerecord_discover/highlighting_formatter'
require 'activerecord_discover/line_numbers_formatter'
require 'activerecord_discover/printer'

require 'activerecord_discover/console_methods'

ActiveRecordDiscover.configure
