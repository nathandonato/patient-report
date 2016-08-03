require 'minitest/autorun'
require 'json'
require 'ostruct'
require_relative '../src/Patient/patients'

class TestPatients < Minitest::Test
  def before_setup
    # This file.read will fail if you try to run this from inside the /test directory
    # Try running in the project root instead using the rake
    json_result = File.read('./test/patients.json')
    @ostructs = JSON.parse(json_result, object_class: OpenStruct)
  end

  def setup
    @patients = Patients.new(@ostructs)
  end

  def test_bad_init
    assert_raises ArgumentError do
      @patients = Patients.new
    end
  end

  def test_empty_init
    @patients = Patients.new([])
    assert_empty @patients.instance_variable_get('@patients')
  end

  def test_build_junk
    assert_raises NoMethodError do
      @patients.build_patient('1')
    end
  end

  def test_build_nil
    assert_raises NoMethodError do
      @patients.build_patient(nil)
    end
  end

  def test_build_patient
    @patients.instance_variable_set('@patients', [])
    @patients.build_patient(@ostructs[0])
    assert_instance_of Patient, @patients.instance_variable_get('@patients')[0]
  end

  def test_new_query
    assert_instance_of PatientQuery, @patients.new_query
  end

  def test_length
    assert_equal 2, @patients.length
  end
end
