require 'fast'
require 'unparser'
require 'rouge'
require 'colorize'

require_relative 'activerecord-discover/helpers/permutator'

require_relative 'activerecord-discover/constants'
require_relative 'activerecord-discover/configuration'
require_relative 'activerecord-discover/console_methods'

require_relative 'activerecord-discover/helpers/path_helper'

require_relative 'activerecord-discover/association/association_list'

require_relative 'activerecord-discover/callback/callback_list'
require_relative 'activerecord-discover/callback/ast_callback'
require_relative 'activerecord-discover/callback/ast_callback_metadata'
require_relative 'activerecord-discover/callback/ast_method'
require_relative 'activerecord-discover/callback/callback_source_location'

require_relative 'activerecord-discover/validation/validation_list'

require_relative 'activerecord-discover/output/line_number_configuration'
require_relative 'activerecord-discover/output/highlighting_formatter'
require_relative 'activerecord-discover/output/line_numbers_formatter'
require_relative 'activerecord-discover/output/printer'

require "activerecord-discover/railtie" if defined?(Rails::Railtie)

ActiveRecordDiscover.configure
