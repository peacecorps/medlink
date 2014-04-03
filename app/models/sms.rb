class SMS < ActiveRecord::Base
  self.table_name = "messages"

  enum direction: [ :incoming, :outgoing ]

  def user
    @_user ||= if parsed.pcv_id
      User.find_by_pcv_id parsed.pcv_id
    else
      User.find_by_phone_number number
    end
  end

  def supplies
    @_supplies ||= begin
      found  = Supply.where shortcode: parsed.shortcodes
      missed = found.map(&:shortcode) - parsed.shortcodes
      raise "Could not find Supplies: #{missed}" if missed.any?
      found
    end
  end

  def create_orders
    supplies.each do |supply|
      Order.create!(
        user_id:      user.id,
        supply_id:    supply.id,
        message_id:   id,
        phone:        number,
        instructions: parsed.instructions,
        entered_by:   user.id
      )
    end
  end

  def send_confirmation orders
    body = raise "NotImplemented: define confirmation message"
    Response.new(number, body).send!
  end

  private

  def parsed
    @_parsed ||= Parser.new(text).tap &:run!
  end
end
