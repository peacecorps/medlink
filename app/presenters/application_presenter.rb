class ApplicationPresenter < Draper::Decorator
  private

  def short_date *args
    h.short_date *args
  end

  def tags *ts
    Array(ts).join(" ").html_safe # TODO: is it safe?
  end

  def list_of *items
    items = Array(items).compact
    h.content_tag :ul do
      tags items.map { |item| h.content_tag :li, item }
    end if items.any?
  end
end
