require "./lib/australia/postcode/version.rb"

Gem::Specification.new do |s|
  s.name        = "australia_postcode"
  s.version     = Australia::Postcode::VERSION
  s.author      = "Charlie Somerville"
  s.email       = "charlie@charliesomerville.com"
  s.homepage    = "https://github.com/charliesome/australia_postcode"
  s.description = "Library for manipulating Australian postcodes"
  s.summary     = "Manipulates Australian postcodes"
  s.files = %w(
    lib/australia_postcode.rb
    lib/australia/postcode.rb
    lib/australia/postcode/version.rb
    lib/australia/postcode/data.csv
  )

  s.add_development_dependency "yard"
end
