class InputBuilder
  def initialize f, opts
    @f, @opts = f, opts
  end

  def method_missing type, name, *args
    opts = args.pop || {}
    label = opts.delete(:label) || name.to_s.split('_').map(&:capitalize).join(' ')
    opts[:class] = [@opts[:class], opts[:class], "form-control"].compact.join " "

    "<div class='form-group'>
       <label for='#{name}'>#{label}</label>
       #{@f.send type, name, *args, opts}
     </div>".squish.html_safe
  end
end

module ApplicationHelper
  def icon name, opts={}
    capture_haml do
      haml_tag "i", class: "glyphicon glyphicon-#{name} #{opts[:class]}"
    end
  end

  def inputs builder, opts={}
    yield InputBuilder.new builder, opts
  end

  def title &block
    capture_haml do
      haml_tag ".title" do
        haml_tag "h2", &block
      end
    end
  end

  def back_link title, path
    link_to path, class: "btn btn-default btn-back" do
      "<i class='glyphicon glyphicon-chevron-left'></i> #{title}".html_safe
    end
  end

  def update_params_link title, param_updates, opts={}
    updated = params.
      reject { |k,v| %w(action controller).include? k }.
      merge param_updates
    link_to title, opts.merge(params: updated)
  end

  def sortable_header table, *args
    update_params_link *table.sorter_for(*args)
  end

  def short_order o
    status = if o.duplicated?
      "Duplicate"
    elsif o.delivery_method
      o.delivery_method.title
    end

    status ? "#{o.supply.name} (#{status})" : o.supply.name
  end

  def short_date date
    date.strftime "%B %d" # January 01
  end
end
