
module NavigationHelpers
  # Maps a name to a path. Used by the
  #
  #   When /^I go to (.+)$/ do |page_name|
  #
  # step definition in web_steps.rb
  #
  def path_to(page_name)
    case page_name
    when /the sign_in page/
      '#/users/sign_in'
    when /the sign_up page/
      '#/users/sign_up'
    when /the forgot_password page/
      '/users/password/new#/new'
    when /the new_order page/
      '/#/orders/new'
    when /the order_table page/
      '/#/orders'
    when /the first_order page/
      '/#/orders/1'
    when /the change_password page/
      '#/users/edit'
    when /the help page/
      '/#/help'
    end
  end
end

World(NavigationHelpers)
