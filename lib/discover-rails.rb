require 'fast'
require 'method_source'
require 'rouge'
require 'colorize'

require_relative 'discover-rails/constants'
require_relative 'discover-rails/configuration'

require_relative 'discover-rails/helpers/permutation_helper'
require_relative 'discover-rails/helpers/path_helper'
require_relative 'discover-rails/helpers/highlight_helper'
require_relative 'discover-rails/helpers/line_number_helper'

require_relative 'discover-rails/association/association_list'

require_relative 'discover-rails/callback/callback_list'
require_relative 'discover-rails/callback/ast_callback'
require_relative 'discover-rails/callback/ast_callback_metadata'
require_relative 'discover-rails/callback/ast_method'
require_relative 'discover-rails/callback/callback_source_location'

require_relative 'discover-rails/validation/validation_list'

require_relative 'discover-rails/printer'

require_relative 'discover-rails/console_methods'

require 'discover-rails/railtie' if defined?(Rails::Railtie)

DiscoverRails.configure
