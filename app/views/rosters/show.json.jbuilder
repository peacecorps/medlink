json.users @roster.rows do |u|
  json.(u, :id, :email, :first_name, :last_name, :role, :location)
  json.phones u.phones.map &:number
end
