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
      new_user_session_path
    when /the start page/
      root_path
    when /the forgot_password page/
      new_user_password_path
    when /the new_order page/
      new_order_path
    when /the request history page/
      orders_path
    when /the first_order page/
      order_path 1
    when /the change_password page/
      edit_user_registration_path
    when /the request_manager page/
      manage_orders_path
    when /the help page/
      help_path
    when /the response page/
      edit_order_path 1
    when /the reports page/
      reports_path
    when /the add user page/
      new_admin_user_path
    when /the edit user page/
      edit_admin_user_path 1
    end
  end
end

World(NavigationHelpers)
