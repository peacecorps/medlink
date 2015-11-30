class ApplicationPresenter < Draper::Decorator
  private

  def short_date *args
    h.short_date *args
  end

  def tags *ts
    Array(ts).join(" ").html_safe # TODO: is it safe?
  end
end
