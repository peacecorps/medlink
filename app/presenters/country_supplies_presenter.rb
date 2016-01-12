class CountrySuppliesPresenter < ApplicationPresenter
  decorates Country
  delegate :id, :name

  class SupplyPresenter < ApplicationPresenter
    delegate :id, :shortcode

    def initialize supply, orderable
      super supply
      @orderable = orderable
    end

    def as_json *_
      model.as_json.merge orderable: @orderable
    end
  end

  def supplies
    @_supplies ||= Supply.globally_available.map { |s| SupplyPresenter.new s, available?(s) }
  end

  private

  def available
    @_available ||= Set.new model.country_supplies.pluck(:supply_id)
  end

  def available? supply
    available.include? supply.id
  end
end
