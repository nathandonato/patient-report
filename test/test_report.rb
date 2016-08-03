require 'minitest/autorun'
require_relative '../src/Report/report'

class TestReport < Minitest::Test
  def setup
    @report = Report.new
  end

  def test_initialize
    assert_equal ['Report:'], @report.instance_variable_get('@report')
    assert_empty @report.instance_variable_get('@columns')
    assert_empty @report.instance_variable_get('@rows')
    assert_empty @report.instance_variable_get('@spacing_counter')
  end

  def test_empty_columns
    assert_raises RuntimeError do
      @report.define_columns
    end
  end

  def test_update_spacing
    @report.update_spacing(['aaaa', 'bb'])
    assert_equal [4, 2], @report.instance_variable_get('@spacing_counter')
  end

  def test_define_columns
    assert_instance_of Report, @report.define_columns('one', 'two')
    assert_equal ['one', 'two'], @report.instance_variable_get('@columns')
  end

  def test_table_integrity
    @report.define_columns('one', 'two')
    assert_raises RuntimeError do
      @report.define_row('just_one')
    end
  end

  def test_define_rows
    @report.define_columns('one', 'two')
    @report.define_row('foo', 'bar')
    @report.define_row('goo', 'car')
    assert_equal [['foo','bar'], ['goo', 'car']], @report.instance_variable_get('@rows')
  end

  def test_draw_line
    @report.define_columns('foo', 'bar')
    assert_equal 10, @report.draw_line.length
  end

  def test_prettify_text
    @report.define_columns('churro', 'sea')
    assert_equal 'churro | sea', @report.prettify_text(@report.instance_variable_get('@columns'))
  end

  def test_prep_header
    @report.define_columns('churro', 'sea')
    @report.prep_header
    assert_equal ['Report:', 'churro | sea', '-------------'], @report.instance_variable_get('@report')
  end
end
