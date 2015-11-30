# TODO:
# * better html (safe) output
# * threadsafe registry?
class SortTable < Draper::Decorator
  class Registry
    Duplicate = Class.new StandardError

    def initialize
      @registry = {}
    end

    def build scope, **opts
      prefix = opts[:prefix]
      raise Duplicate if @registry.include? prefix
      @registry[prefix] = SortTable.send :new, scope, opts
    end
  end

  delegate_all

  class << self
    protected :new
  end

  def initialize scope, params:, prefix: nil, default: nil, sort_model: nil, per_page: nil, presenter: nil
    @scope     = scope
    @params    = params.clone.reject { |k| %w( action controller ).include?(k) }
    @prefix    = prefix ? "#{prefix}_" : ""
    @default   = default || { id: :asc }
    @model     = sort_model || @scope.model
    @per_page  = per_page
    @presenter = presenter

    super page
  end

  def anchor
    "#{model_name}_#{prefix}table"
  end

  def page_param
    "#{prefix}page"
  end

  def header col, title: nil
    col     = col.to_s
    title ||= col.titleize

    if col == sort_column.to_s
      klass = "current #{sort_direction}"
      dir = sort_direction == :asc ? :desc : :asc
    else
      klass = nil
      dir = :asc
    end

    p = params.merge "#{prefix}sort" => col, "#{prefix}direction" => dir
    "<a class='#{klass}' href='?#{p.to_query}##{anchor}'>#{title}</a>".html_safe
  end

  private

  attr_reader :scope, :model, :prefix, :params, :per_page, :default

  def ordered
    scope.order "#{model.table_name}.#{sort_column} #{sort_direction}"
  end

  def page
    ordered.page(params[page_param]).per(per_page)
  end

  def model_name
    model.model_name.singular
  end

  def allowed_columns
    model.column_names
  end

  def sort_column
    given = params["#{prefix}sort"]
    allowed_columns.include?(given) ? given : default.keys.first
  end

  def sort_direction
    given = params["#{prefix}direction"]
    %w(asc desc).include?(given) ? given.to_sym : default.values.first
  end
end
