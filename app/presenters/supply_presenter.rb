class SupplyPresenter < ApplicationPresenter
  # TODO: unify with CountrySuppliesPresenter::SupplyPresenter?
  delegate :shortcode, :orderable?

  def name
    if orderable?
      h.content_tag "span", model.name
    else
      h.content_tag "s", model.name
    end
  end

  def global_toggle_btn
    klass, icon = orderable? ? [:danger, :remove] : [:default, :ok]

    h.content_tag(:a, "", name: "supply_#{model.shortcode}") + \
    h.button_to(h.toggle_orderable_supply_url(model), method: :patch,
              class: "btn btn-#{klass} .toggle_orderable_supply") do
      h.icon icon
    end
  end
end
