require 'hocon/impl'

class Hocon::Impl::ConfigReference < Hocon::Impl::AbstractConfigValue
  include Hocon::Impl::Unmergeable

  def initialize(origin, expr, prefix_length = 0)
    super(origin)
    @expr = expr
    @prefix_length = prefix_length
  end

  attr_reader :expr, :prefix_length


end