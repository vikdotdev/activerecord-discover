require_relative 'content_for'

class TemplateWriteFailed < StandardError
  def initialize(template, err)
    message = <<~ERROR
      #{self.class} for #{template.inspect}
      Caused by #{err.message}
    ERROR

    super(message)
  end
end

class BaseTemplate
  include ContentFor

  attr_reader :name, :filename, :template, :template_name

  def initialize(template_name, variables = {})
    @template_name = template_name
    @name = "#{template_name}#{SecureRandom.hex(4)}".camelize
    @filename = @name.to_s.underscore.downcase
    variables.each { |key, value| instance_variable_set("@#{key}", value) }
  end

  def setup
    File.open(destination_path(@filename), 'w+') do |f|
      @template = render_erb(File.read(template_path(@template_name)), binding)
      f.write(template)
    end

    self
  rescue Errno::ENOENT => e
    raise TemplateWriteFailed.new(self, e)
  end

  def template_path(name)
    raise NotImplemented
  end

  def destination_path(name)
    raise NotImplemented
  end

  protected

  def from_current_dir(*path)
    File.join(File.dirname(__FILE__), *path)
  end
end

class ModelTemplate < BaseTemplate
  def self.clean
    model_paths = File.join(File.dirname(__FILE__), '../dummy/app/models', '*.rb')
    Dir.glob(model_paths).map { |path| File.delete(path) }
  end

  def template_path(name)
    from_current_dir('../templates/models', "#{name}.erb")
  end

  def destination_path(name)
    from_current_dir('../dummy/app/models', "#{name}.rb")
  end
end

class ConcernTemplate < BaseTemplate
  def self.clean
    concern_paths = File.join(File.dirname(__FILE__), '../dummy/app/models/concerns', '*.rb')
    Dir.glob(concern_paths).map { |path| File.delete(path) }
  end

  def template_path(name)
    from_current_dir('../templates/concerns', "#{name}.erb")
  end

  def destination_path(name)
    from_current_dir('../dummy/app/models/concerns', "#{name}.rb")
  end
end

module ModelHelper
  def model_setup(*args)
    ModelTemplate.new(*args).setup
  end

  def concern_setup(*args)
    ConcernTemplate.new(*args).setup
  end
end
