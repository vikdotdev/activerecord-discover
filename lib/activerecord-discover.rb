require 'fast'
require 'method_source'
require 'rouge'
require 'colorize'

require_relative 'activerecord-discover/constants'
require_relative 'activerecord-discover/configuration'

require_relative 'activerecord-discover/helpers/permutation_helper'
require_relative 'activerecord-discover/helpers/path_helper'
require_relative 'activerecord-discover/helpers/highlight_helper'
require_relative 'activerecord-discover/helpers/line_number_helper'

require_relative 'activerecord-discover/association/association_list'

require_relative 'activerecord-discover/ast_entity_list'
require_relative 'activerecord-discover/ast_entity'

require_relative 'activerecord-discover/callback/ast_callback_patterns'
require_relative 'activerecord-discover/callback/ast_callback_list'
require_relative 'activerecord-discover/callback/ast_callback'
require_relative 'activerecord-discover/callback/ast_method'
require_relative 'activerecord-discover/callback/callback_source_location'

require_relative 'activerecord-discover/validation/ast_validation_patterns'
require_relative 'activerecord-discover/validation/ast_validation'
require_relative 'activerecord-discover/validation/ast_validation_list'

require_relative 'activerecord-discover/printer'

require_relative 'activerecord-discover/console_methods'

require "activerecord-discover/railtie" if defined?(Rails::Railtie)

ActiveRecordDiscover.configure
