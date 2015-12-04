class GroupedOrdersPresenter
  class Group < ApplicationPresenter
    attr_reader :request

    def initialize request, orders
      @request = RequestPresenter.new request
      @orders  = orders
    end

    def each
      return enum_for :each unless block_given?
      @orders.each_with_index { |o,i| yield OrderResponsePresenter.new(o), i }
    end

    def size
      @orders.count
    end

    def created_at
      tags \
        short_date(request.created_at, request.user.time_zone),
        h.content_tag(:small, request.created_at.strftime("%H:%M"))
    end
  end

  include Enumerable

  def initialize orders
    @groups = orders.
      group_by(&:request).
      sort_by { |request, _| request.created_at }.
      reverse.
      map { |req, os| Group.new(req, os) }
  end

  def each_group
    return enum_for :each_group unless block_given?
    @groups.each { |g| yield g }
  end
end
