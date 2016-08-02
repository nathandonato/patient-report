require 'json'
require '../src/util/search.rb'

json_result = File.read('./test.json')
parsed = JSON.parse(json_result, object_class: OpenStruct)
found = []

parsed.each { |p|
  if Search.new().find(p, 'w', 'b', 'Yee')
    found.push(p)
  end
}

puts found