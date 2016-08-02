class Search
  def initialize
    @found = false
  end

  def find(obj, *keys)
    @val = keys.last
    iterate(obj, *keys - [@val])
    @found
  end

  def iterate(obj, *keys)
    if obj.to_s == @val.to_s
      @found = true
    elsif obj.is_a? Array
        obj.each { |i| iterate(i, *keys) }
    elsif obj.is_a? OpenStruct or obj.is_a? Struct
      obj.each_pair { |k, v|
        if k.to_s == keys[0]
          new_keys = keys - [keys[0]]
          iterate(v, *new_keys)
        end
      }
    end
  end
end
