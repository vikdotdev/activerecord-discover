require 'fast'
require 'unparser'
require 'rouge'
require 'colorize'

require_relative 'activerecord-discover/constants'
require_relative 'activerecord-discover/configuration'

require_relative 'activerecord-discover/permutator'
require_relative 'activerecord-discover/association_list'
require_relative 'activerecord-discover/validation_list'
require_relative 'activerecord-discover/callback_list'

require_relative 'activerecord-discover/ast_callback'
require_relative 'activerecord-discover/ast_callback_metadata'
require_relative 'activerecord-discover/ast_method'
require_relative 'activerecord-discover/callback_source_location'
require_relative 'activerecord-discover/line_number_configuration'

require_relative 'activerecord-discover/highlighting_formatter'
require_relative 'activerecord-discover/line_numbers_formatter'
require_relative 'activerecord-discover/printer'

require_relative 'activerecord-discover/console_methods'
require "activerecord-discover/railtie" if defined?(Rails::Railtie)

ActiveRecordDiscover.configure
