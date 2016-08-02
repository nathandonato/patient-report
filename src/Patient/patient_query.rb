require_relative 'patients'

class PatientQuery
  def initialize(patients)
    @patients = patients
    @query = patients
  end

  def with(*args)
    hits = []

    @query.each { |p|
      if p.has_property(*args)
        hits.push(p)
      end
    }

    @query = hits
    self
  end

  def is_age(operator, target_age)
    hits = []

    @query.each { |p|
      if p.age.send(operator, target_age)
        hits.push(p)
      end
    }

    @query = hits
    self
  end


  def get
    Patients.new(@query)
  end

  def get_opposite
    opposite = @patients - @query
    Patients.new(opposite)
  end
end
