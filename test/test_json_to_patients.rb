require 'minitest/autorun'
require_relative '../src/Patient/json_to_patients'

class TestJsonToPatients < Minitest::Test
  def setup
    # This file.read will fail if you try to run this from inside the /test directory
    # Try running in the project root instead using the rake
    @json = File.read('./test/patients.json')
    @jtp = JsonToPatients.new(@json)
  end

  def test_data_type
    assert_instance_of JsonToPatients, @jtp
  end

  def test_initialize
    assert_instance_of Array, @jtp.instance_variable_get('@patients')
  end

  def test_patients
    assert_instance_of Patients, @jtp.patients
  end
end
