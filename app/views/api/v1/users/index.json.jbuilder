json.users @users do |u|
  json.(u, :id, :email, :first_name, :last_name, :role, :pcv_id, :location, :active)
  json.phones u.phones.map &:number
end
