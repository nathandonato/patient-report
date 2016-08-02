require_relative '../util/search'

Patient = Struct.new(:id, :birthdate, :gender, :procedures, :results) do
  def has_property(*args)
    return Search.new.find(self, *args)
  end

  def age
    dob = DateTime.parse(birthdate)
    now = Time.now.utc.to_date
    return now.year - dob.year - ((now.month > dob.month || (now.month == dob.month && now.day >= dob.day)) ? 0 : 1)
  end
end
