class CountrySuppliesPresenter < ApplicationPresenter
  decorates Country
  delegate :id, :name

  class SupplyPresenter < ApplicationPresenter
    delegate :id, :shortcode

    def initialize supply, available
      super supply
      @available = available
    end

    def available?
      @available
    end

    def name
      if available?
        h.content_tag "span", model.name
      else
        h.content_tag "s", model.name
      end
    end

    def toggle_button
      klass, icon = available? ? [:danger, :remove] : [:default, :ok]
      h.button_to h.toggle_country_supply_path(model), method: :patch,
                  class: "btn btn-#{klass} .toggle_orderable_supply" do
        h.icon icon
      end
    end
  end

  def supplies
    @_supplies ||= Supply.all.map { |s| SupplyPresenter.new s, available?(s) }
  end

  private

  def available
    @_available ||= Set.new model.country_supplies.pluck(:supply_id)
  end

  def available? supply
    available.include? supply.id
  end
end
