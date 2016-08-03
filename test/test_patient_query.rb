require 'minitest/autorun'
require_relative '../src/Patient/patient_query'
require_relative '../src/Patient/patient'

class TestPatientQuery < Minitest::Test
  def before_setup
    # This file.read will fail if you try to run this from inside the /test directory
    # Try running in the project root instead using the rake
    json_result = File.read('./test/patients.json')
    @ostructs = JSON.parse(json_result, object_class: OpenStruct)
    @patients = [Patient.new(1, '1992-02-29', 'F', [], %w(r)), Patient.new(2, '1992-02-29', 'M', %w(p), [])]
  end

  def setup
    @query = PatientQuery.new(@patients)
    @current_age = calculate_age(@patients[0])
  end

  def test_data_type
    assert_instance_of PatientQuery, @query
  end

  def test_with_return
    assert_instance_of PatientQuery, @query.with('foo', 'bar')
  end

  def test_with_hits
    assert_equal([@patients[0]], @query.with('gender', 'F').instance_variable_get('@query'))
  end

  def test_without_hits
    assert_equal([], @query.with('foo', 'bar').instance_variable_get('@query'))
  end

  def test_age_return
    assert_instance_of PatientQuery, @query.age?('==', 0)
  end

  def test_age_equal
    assert_equal(@patients, @query.age?('==', @current_age).instance_variable_get('@query'))
  end

  def test_age_less
    assert_equal(@patients, @query.age?('<', @current_age + 1).instance_variable_get('@query'))
  end

  def test_age_greater
    assert_equal(@patients, @query.age?('>', @current_age - 1).instance_variable_get('@query'))
  end

  def test_age_less_equal
    assert_equal(@patients, @query.age?('<=', @current_age).instance_variable_get('@query'))
  end

  def test_age_greater_equal
    assert_equal(@patients, @query.age?('>=', @current_age).instance_variable_get('@query'))
  end

  def test_age_not
    assert_equal(@patients, @query.age?('!=', @current_age - 1).instance_variable_get('@query'))
  end

  def test_get_return
    assert_instance_of Patients, @query.get
  end

  def test_get_nothing_return
    @query.instance_variable_set('@query', [])
    assert_instance_of Patients, @query.get
  end

  def test_get_opposite_return
    @query.instance_variable_set('@query', [])
    assert_instance_of Patients, @query.get_opposite
  end

  def test_get_opp_nothing_return
    assert_instance_of Patients, @query.get_opposite
  end

  def test_get_nothing
    assert_equal([], @query.age?('==', @current_age - 1).get.instance_variable_get('@patients'))
  end

  def test_get_opposite_nothing
    assert_equal([], @query.age?('==', @current_age).get_opposite.instance_variable_get('@patients'))
  end

  def test_get
    assert_equal(@patients, @query.age?('==', @current_age).get.instance_variable_get('@patients'))
  end

  def test_get_opposite
    assert_equal(@patients, @query.age?('==', @current_age - 1).get_opposite.instance_variable_get('@patients'))
  end

  def calculate_age(patient)
    dob = DateTime.parse(patient.birthdate)
    now = Time.now.utc.to_date
    now.year - dob.year - ((now.month > dob.month || (now.month == dob.month && now.day >= dob.day)) ? 0 : 1)
  end
end
