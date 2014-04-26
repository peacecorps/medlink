module ApplicationHelper
  def icon name
    "<i class='glyphicon glyphicon-#{name}'></i>".html_safe
  end

  def current_country
    @_current_country ||= current_user.country.name
  end
end
