# Loads pry if available (notably, not on Travis)
begin
  require 'pry'
rescue LoadError
end
