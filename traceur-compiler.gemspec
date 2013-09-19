Gem::Specification.new do |spec|
	spec.name = 'traceur-compiler'
	spec.version = '0.1.2'
	spec.summary = 'Traceur compiler'
	spec.license = 'New BSD license'
	spec.homepage = 'https://github.com/jakub-/ruby-traceur-compiler'
	
	spec.author = 'Jakub'
	spec.email = 'jakub@jakub.cc'

	spec.add_dependency 'activesupport'
	spec.add_dependency 'execjs'
	spec.add_dependency 'therubyracer'
	spec.add_dependency 'traceur-compiler-source'

	spec.add_development_dependency 'rspec'
	spec.add_development_dependency 'rspec-expectations', '~> 2.14.0'
	
	spec.files = [
		'lib/traceur_compiler.rb'
	]
end
