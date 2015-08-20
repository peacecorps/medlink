class SortTable
  include Enumerable

  attr_reader :prefix

  def initialize scope, params:,  prefix: nil, default: nil, sort_model: nil, per_page: nil
    @scope    = scope
    @params   = params.clone
    @prefix   = prefix ? "#{prefix}_" : ""
    @default  = default || { id: :asc }
    @model    = sort_model || @scope.model
    @per_page = per_page
  end

  def ordered
    @scope.order "#{@model.table_name}.#{sort_column} #{sort_direction}"
  end

  def page_param
    "#{prefix}page"
  end
  def page
    ordered.page(@params[page_param]).per(@per_page)
  end

  def each
    page.each { |rec| yield rec }
  end

  def model_name
    @model.model_name.singular
  end

  def allowed_columns
    @model.column_names
  end

  def sort_column
    given = @params["#{prefix}sort"]
    allowed_columns.include?(given) ? given : @default.keys.first
  end

  def sort_direction
    given = @params["#{prefix}direction"]
    %w(asc desc).include?(given) ? given.to_sym : @default.values.first
  end

  def anchor
    "#{model_name}_#{prefix}table"
  end

  def sorter_for column, title: nil
    column  = column.to_s
    title ||= column.titleize

    if column == sort_column
      css = "current #{sort_direction}"
      dir = sort_direction == :asc ? :desc : :asc
    else
      css = nil
      dir = :asc
    end

    [
      title,
      { "#{prefix}sort" => column, "#{prefix}direction" => dir },
      { class: css, anchor: anchor }
    ]
  end
end
