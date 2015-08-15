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
    status = order_status o
    status ? "#{o.supply.name} (#{status})" : o.supply.name
  end

  def order_status o
    status = if o.duplicated?
      "Duplicate"
    elsif o.delivery_method
      o.delivery_method.title
    end
  end

  def short_date date, zone=nil
    date = date.in_time_zone zone if zone
    if date.year == Time.now.year
      date.strftime "%B %d" # January 01
    else
      date.strftime "%B %d, %Y"
    end
  end

  def phone_link phone
    if phone
      link_to phone.number, "tel:#{phone.number}"
    else
      "-"
    end
  end
end
