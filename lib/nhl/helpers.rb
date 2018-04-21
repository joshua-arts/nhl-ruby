# A set of common helper methods used by many of the object classes.

require 'date'

# For converting a day string to a day number.
def convert_day(d)
  Date::DAYNAMES.index(d.downcase.capitalize) + 1
end

# For converting a month string to a month number.
def convert_month(m)
  m = m.downcase.capitalize
  Date::MONTHNAMES.index(m) || Date::ABBR_MONTHNAMES.index(m)
end

# For converting camelCase JSON keys to snake_case.
def underscore(s)
  s.gsub('.', '_').gsub(/(.)([A-Z])/, '\1_\2').downcase
end

# For converting search queries before testing for API matches.
def titleize(s)
  s.split.map(&:capitalize).join(' ')
end

# Sets instance variables for a class from a list of attributes.
def set_instance_variables(attributes, data)
  attributes.each do |att|
    instance_variable_set(
      "@" + underscore(att),
      traverse_hash(data, att.split('.'))
    )
  end
end

# Recursively traverse a hash.
def traverse_hash(data, keys)
  return data[keys.first] if keys.length <= 1
  traverse_hash(data[keys.shift], keys)
end

# Initializes getters for all class instance variables.
def initialize_getters
  instance_variables.each do |v|
    define_singleton_method(v.to_s.tr('@','')) do
      instance_variable_get(v)
    end
  end
end