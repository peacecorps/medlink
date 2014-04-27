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
  def icon name
    "<i class='glyphicon glyphicon-#{name}'></i>".html_safe
  end

  def users_by_country
    User.includes(:country).to_a.group_by(&:country).map do |c,us|
      [c.name, us.map { |u| [u.name, u.id] }]
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
end
