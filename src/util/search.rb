# Search arrays, Structs, and OpenStructs (or any combination) to find a value
# find(haystack, "keys", "to", needle)
class Search
  def initialize
    @path_to_item = nil
  end

  def find(obj, *keys)
    if obj.nil? || keys[0].nil?
      raise 'Must specify a needle and a haystack'
    end

    @val = keys.last
    iterate(obj, *keys - [@val], [])
    @path_to_item
  end

  def iterate(obj, *keys, path)
    if obj == @val && keys.empty?
      @path_to_item = path
      @found = true
    elsif obj.is_a? Array
      obj.each { |i|
        new_path = path + [i]
        iterate(i, *keys, new_path)
      }
    elsif (obj.is_a? OpenStruct) || (obj.is_a? Struct)
      check_struct(obj, *keys, path)
    end
  end

  def check_struct(obj, *keys, path)
    obj.each_pair do |k, v|
      if k.to_s == keys[0]
        new_keys = keys - [keys[0]]
        new_path = path + [[keys[0]]]
        iterate(v, *new_keys, new_path)
      end
    end
  end
end
