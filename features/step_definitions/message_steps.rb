def pos_ack_msg(msg)
  page.should have_content "#{msg}"
end

def err_msg(msg)
  page.should have_content "#{msg}"
  # CHECK FOR COLOR.
end

def no_err_msg(msg)
  page.should_not have_content "#{msg}"
  # CHECK FOR COLOR.
end
#save_and_open_page
