module ApplicationHelper
  def icon name
    "<i class='glyphicon glyphicon-#{name}'></i>".html_safe
  end

  def current_country
    @_current_country ||= current_user.country.name
  end

  def users_by_country
    User.includes(:country).to_a.group_by(&:country).map do |c,us|
      [c.name, us.map { |u| [u.name, u.id] }]
    end
  end
end
