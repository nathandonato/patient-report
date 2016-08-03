require 'minitest/autorun'
require 'json'
require_relative '../src/util/search.rb'

class TestSearch < Minitest::Test
  def before_setup
    # This file.read will fail if you try to run this from inside /test
    # Try running in the project root instead using the rake
    json_result = File.read('./test/search.json')
    @open = JSON.parse(json_result, object_class: OpenStruct)

    @nested_struct = TStruct.new(4, 'bar', false, true, [2, 'b'], @open)
    @struct = TStruct.new(3, 'foo', false, true, [1, 'a'], @open, @nested_struct)
  end

  def setup
    @search = Search.new
  end

  def test_data_read
    assert_instance_of OpenStruct, @open
  end

  def test_default_found
    assert_nil @search.instance_variable_get('@path_to_item')
  end

  def test_find_nil
    assert_raises RuntimeError do
      @search.find(nil)
    end
  end

  def test_keys_nil
    assert_raises RuntimeError do
      @search.find(%w(foo bar), nil)
    end
  end

  def test_type_integrity
    assert_nil @search.find(3, '3')
  end

  def test_int_match
    refute_nil @search.find(3, 3)
  end

  def test_string_match
    refute_nil @search.find('3', '3')
  end

  def test_false_match
    refute_nil @search.find(false, false)
  end

  def test_true_match
    refute_nil @search.find(true, true)
  end

  def test_array_match
    refute_nil @search.find(%w(hey), %w(hey))
  end

  def test_struct_match
    refute_nil @search.find(@struct, @struct)
  end

  def test_int_no_match
    assert_nil @search.find(3, 5)
  end

  def test_string_no_match
    assert_nil @search.find('3', 'm')
  end

  def test_false_no_match
    assert_nil @search.find(false, 0)
  end

  def test_true_no_match
    assert_nil @search.find(true, 1)
  end

  def test_array_no_match
    assert_nil @search.find(%w(hey), %w(bye))
  end

  def test_struct_no_match
    assert_nil @search.find(@struct, 'x')
  end

  def test_int_in_array_match
    refute_nil @search.find([3], 3)
  end

  def test_string_in_array_match
    refute_nil @search.find(['3'], '3')
  end

  def test_false_in_array_match
    refute_nil @search.find([false], false)
  end

  def test_true_in_array_match
    refute_nil @search.find([true], true)
  end

  def test_array_in_array_match
    refute_nil @search.find(['b', ['2']], ['2'])
  end

  def test_struct_in_array_match
    refute_nil @search.find([@struct], @struct)
  end

  def test_os_in_array_match
    refute_nil @search.find([@open], @open)
  end

  def test_int_in_array_no_match
    assert_nil @search.find([3], 5)
  end

  def test_string_in_array_no_match
    assert_nil @search.find(['3'], 'm')
  end

  def test_false_in_array_no_match
    assert_nil @search.find([false], 'false')
  end

  def test_true_in_array_no_match
    assert_nil @search.find([true], 1)
  end

  def test_array_in_array_no_match
    assert_nil @search.find(['b', [1, '2']], ['2'])
  end

  def test_struct_in_array_no_match
    assert_nil @search.find([@open], @struct)
  end

  def test_os_in_array_no_match
    assert_nil @search.find([@struct], @open)
  end

  def test_int_in_struct_match
    refute_nil @search.find(@struct, 'int', 3)
  end

  def test_string_in_struct_match
    refute_nil @search.find(@struct, 'string', 'foo')
  end

  def test_false_in_struct_match
    refute_nil @search.find(@struct, 'f', false)
  end

  def test_true_in_struct_match
    refute_nil @search.find(@struct, 't', true)
  end

  def test_struct_in_struct_match
    refute_nil @search.find(@struct, 'struct', @nested_struct)
  end

  def test_os_in_struct_match
    refute_nil @search.find(@struct, 'open', @open)
  end

  def test_array_in_struct_match
    refute_nil @search.find(@struct, 'array', [1, 'a'])
  end

  def test_int_in_struct_no_match
    assert_nil @search.find(@struct, 'int', 10)
  end

  def test_string_in_struct_no_match
    assert_nil @search.find(@struct, 'string', 'boo')
  end

  def test_false_in_struct_no_match
    assert_nil @search.find(@struct, 'f', 0)
  end

  def test_true_in_struct_no_match
    assert_nil @search.find(@struct, 't', 1)
  end

  def test_array_in_struct_no_match
    assert_nil @search.find(@struct, 'array', [2, 'a'])
  end

  def test_struct_in_struct_no_match
    assert_nil @search.find(@nested_struct, 'struct', @struct)
  end

  def test_os_in_struct_no_match
    new_ostruct = @open.clone
    new_ostruct.delete_field('x')

    assert_nil @search.find(@struct, 'open', new_ostruct)
  end

  def test_int_in_os_match
    refute_nil @search.find(@open, 'x', 'b', 2)
  end

  def test_string_in_os_match
    refute_nil @search.find(@open, 'w', 'b', 'Yee')
  end

  def test_true_in_os_match
    refute_nil @search.find(@open, 'w', 'f', true)
  end

  def test_false_in_os_match
    refute_nil @search.find(@open, 'y', 'c', false)
  end

  def test_array_in_os_match
    refute_nil @search.find(@open, 'y', 'b', %w(Nee Yee))
  end

  def test_int_in_os_no_match
    assert_nil @search.find(@open, 'y', 'b', 1)
  end

  def test_string_in_os_no_match
    assert_nil @search.find(@open, 'y', 'b', 'won\'t find')
  end

  def test_true_in_os_no_match
    assert_nil @search.find(@open, 'y', true)
  end

  def test_false_in_os_no_match
    assert_nil @search.find(@open, 'y', false)
  end

  def test_array_in_os_no_match
    assert_nil @search.find(@open, 'y', 'b', %w(Yee Ree))
  end
end

TStruct = Struct.new(:int, :string, :f, :t, :array, :open, :struct)
