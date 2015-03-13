require 'hocon/impl'

class Hocon::Impl::ConfigReference < Hocon::Impl::AbstractConfigValue
  include Hocon::Impl::Unmergeable

  def initialize(origin, expr, prefix_length = 0)
    super(origin)
    @expr = expr
    @prefix_length = prefix_length
  end

  attr_reader :expr, :prefix_length

  def self.not_resolved
    error_message = "need to Config#resolve, see the API docs for Config#resolve; substitution not resolved: #{self}"
    Hocon::ConfigError::ConfigNotResolvedError.new(error_message, nil)
  end

  def value_type
    raise self.class.not_resolved
  end

  def unwrapped
    raise self.class.not_resolved
  end

  def new_copy(new_origin)
    Hocon::Impl::ConfigReference.new(new_origin, @expr, @prefix_length)
  end

  def ignores_fallbacks
    false
  end

  def resolve_status
    Hocon::Impl::ResolveStatus::UNRESOLVED
  end

  def relativized(prefix)
    new_expr = @expr.change_path(@expr.path,prepend(prefix))

    Hocon::Impl::ConfigReference.new(origin, new_expr, @prefix_length + prefix.length)
  end

  def can_equal(other)
    other.is_a? Hocon::Impl::ConfigReference
  end

  def ==(other)
    # note that "origin" is deliberately NOT part of equality
    if other.is_a? Hocon::Impl::ConfigReference
      can_equal(other) && @expr == other.expr
    end
  end

  def hash
    # note that "origin" is deliberately NOT part of equality
    @expr.hash
  end

  def render(sb, indent, at_root, options)
    sb.append(@expr.to_s)
  end

end
