module ApplicationHelper
  def icon name, opts={}
    klass = ["glyphicon", "glyphicon-#{name}", opts[:class]].compact.join " "
    content_tag :i, "", class: klass
  end

  def title text=nil
    content_tag :div, class: "title" do
      content_tag :h2 do
        text || yield
      end
    end
  end

  def back_link title, path
    link_to path, class: "btn btn-default btn-back" do
      concat icon("chevron-left")
      concat content_tag(:span, " #{title}")
    end
  end

  def short_order o
    status = order_status o
    status ? "#{o.supply.name} (#{status})" : o.supply.name
  end

  def order_status o
    if o.duplicated?
      "Duplicated"
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

  def update_params_link title, param_updates, opts={}
    updated = params.
              reject { |k,v| %w(action controller).include? k  }.
              merge param_updates
    link_to title, opts.merge(params: updated)
  end
end
