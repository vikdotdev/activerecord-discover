module ContentFor
  def content_blocks
    @content_blocks ||= {}
  end

  def render_erb(content, binding)
    ERB.new(content, nil, nil,  '@_erbout').result(binding)
  end

  def content_for(key, &block)
    content_blocks[key.to_sym] = capture_later(&block)
    block.call
  end

  def yield_content(key)
    return if content_blocks[key.to_sym].nil?

    content_blocks[key.to_sym].yield_self { |block| capture(&block) }
  end

  private

  def capture_later(&block)
    proc { |*| @capture = capture(&block) }
  end

  def capture
    @capture = nil
    @_erbout, _buf_was = '', @_erbout
    result = yield
    @_erbout = _buf_was
    result.strip.empty? && @capture ? @capture : result
  end
end

