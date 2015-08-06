module ApplicationHelper
  def icon name, opts={}
    capture_haml do
      haml_tag "i", class: "glyphicon glyphicon-#{name} #{opts[:class]}"
    end
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
