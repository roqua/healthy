guard 'rspec', cli: '-f Fuubar' do
  watch(%r{^spec/.+_spec\.rb$})
  watch(%r{^lib/healthy/(.+)\.rb$}) { |m| ["spec/unit/#{m[1]}_spec.rb", "spec/integration"] }
  watch('spec/spec_helper.rb')  { "spec" }
  watch(%r{^spec/fixtures/([^_]+)_.*.xml}) { |m| "spec/integration/#{m[1]}_spec.rb" }
end

guard :rubocop do
  watch(%r{.+\.rb$})
  watch(%r{(?:.+/)?\.rubocop\.yml$}) { |m| File.dirname(m[0]) }
end
