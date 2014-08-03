class Report::Users < Report
  def initialize users
    self.rows = users.includes :phones, :country
  end

  def format user
    phone   = user.primary_phone
    country = user.country

    {
      "Create Date" => user.created_at,
      "PCV ID"      => user.pcv_id,
      "First"       => user.first_name,
      "Last"        => user.last_name,
      "Email"       => user.email,
      "Phone"       => phone.try(:number),
      "Country"     => country.name,
      "Role"        => user.role,
      "Location"    => user.location
    }
  end
end
