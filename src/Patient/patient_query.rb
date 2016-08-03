require_relative 'patients'

class PatientQuery
  def initialize(patients)
    @patients = patients
    @query = patients
  end

  def with(*args)
    hits = []

    @query.each { |p|
      if p.property?(*args)
        hits.push(p)
      end
    }

    @query = hits
    self
  end

  def age?(operator, target_age)
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
    Patients.new(@patients - @query)
  end
end
