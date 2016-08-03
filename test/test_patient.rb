require 'minitest/autorun'
require 'json'
require 'date'
require_relative '../src/Patient/patient'

class TestPatient < Minitest::Test
  def setup
    @patient = Patient.new(1, '1991-02-28', 'F', [], [])
  end

  def test_property
    refute_nil @patient.property?('gender', 'F')
  end

  def test_does_not_have_property
    assert_nil @patient.property?('gender', 'M')
  end

  def test_age
    assert_instance_of Fixnum, @patient.age
  end

  def test_leap_year_age
    @patient.birthdate = '1992-02-29'
    assert_instance_of Fixnum, @patient.age
  end

  def test_bad_birthdate
    @patient.birthdate = '1991-02-29'
    assert_raises ArgumentError do
      @patient.age
    end
  end
end
