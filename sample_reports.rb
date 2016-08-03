require 'date'
require 'http'
require './src/Patient/json_to_patients'
require './src/Report/report'

if !ARGV.empty? && ARGV[0] == 'dev'
  puts 'Reading JSON stored locally.'
  json_result = File.read('./sample.json')
else
  puts 'Getting JSON...'
  json_result = HTTP.get('http://private-ab2d42-healthefilings.apiary-mock.com/patients2')
  puts 'Got JSON!'
end

patients = JsonToPatients.new(json_result).patients

##############
# Colonoscopy
##############

# Queries
colo_query = patients.new_query.with('procedures', 'codes', 'CPT', '45378')
have_colo  = colo_query.get
miss_colo  = colo_query.get_opposite

gender_have = have_colo.new_query.with('gender', 'F')
f_have      = gender_have.get
m_have      = gender_have.get_opposite

gender_miss = miss_colo.new_query.with('gender', 'F')
f_miss      = gender_miss.get
m_miss      = gender_miss.get_opposite

# Report
puts Report.new('Colonoscopy')
  .define_columns('Gender', 'Have colonoscopy', 'Missing colonoscopy')
  .define_row('M', m_have.length, m_miss.length)
  .define_row('F', f_have.length, f_miss.length)
  .print_report

######
# BMI
######

# Queries
bmi_query = patients.new_query.with('results', 'codes', 'LOINC', '39156-5')
high_bmi  = bmi_query.get
low_bmi   = bmi_query.get_opposite

age_high   = high_bmi.new_query.age?('>=', 65)
old_high   = age_high.get
young_high = age_high.get_opposite.new_query.age?('>=', 18).get

age_low    = low_bmi.new_query.age?('>=', 65)
old_low    = age_low.get
young_low  = age_low.get_opposite.new_query.age?('>=', 18).get

# Report
puts Report.new('BMI')
  .define_columns('Age', 'Overweight', 'Not overweight')
  .define_row('18-64', young_high.length, young_low.length)
  .define_row('65+', old_high.length, old_low.length)
  .print_report
