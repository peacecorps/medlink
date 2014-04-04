module ApplicationHelper
  def icon name
    "<i class='glyphicon glyphicon-#{name}'></i>".html_safe
  end
end
