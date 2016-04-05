json.users @users do |u|
  json.(u, :id, :email, :first_name, :last_name, :role, :location, :active)
  json.country u.country.name
  json.phones u.phones.map &:number
end
