require 'json'
require 'ostruct'
require_relative 'patients'

class JsonToPatients
  def initialize(obj)
    @patients = JSON.parse(obj, object_class: OpenStruct)
  end

  def patients
    Patients.new(@patients)
  end
end
