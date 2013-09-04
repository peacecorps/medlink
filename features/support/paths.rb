
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
      '/users/sign_in'
    when /the admin home page/
      '/users/sign_up'
    when /the admin start page/
      '/admin'
    when /the add user page/
      '/admin/users/new'
    when /the admin edit page/
      '/admin/users/1/edit'
    when /the forgot_password page/
      '/users/password/new'
    when /the new_order page/
      '/orders/new'
    when /the request history page/
      '/orders'
    when /the pcmo start page/
      '/orders'
    when /the first_order page/
      '/orders/1'
    when /the change_password page/
      '/users/edit'
    when /the request_manager page/
      '/orders/manage'
    when /the help page/
      '/help'
    end
  end
end

World(NavigationHelpers)
