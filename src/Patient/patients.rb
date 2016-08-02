require 'json'
require_relative 'patient'
require_relative 'patient_query'

class Patients
  def initialize(patients)
    @patients = []
    patients.each { |p| build_patient(p) }
  end

  def build_patient(patient)
    @patients.push(Patient.new(patient.id, patient.birthdate, patient.gender, patient.procedures, patient.results))
  end

  def new_query
    PatientQuery.new(@patients)
  end

  def length
    @patients.length
  end
end
