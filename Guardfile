guard 'rspec', cli: '-f Fuubar' do
  watch(%r{^spec/.+_spec\.rb$})
  watch(%r{^lib/healthy/(.+)\.rb$}) { |m| ["spec/unit/#{m[1]}_spec.rb", "spec/integration"] }
  watch('spec/spec_helper.rb')  { "spec" }
end