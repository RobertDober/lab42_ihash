
base = File.dirname __FILE__
$:.unshift File.join( base, 'lib' )

require 'lab42/ihash/version'

Gem::Specification.new do | spec |
  spec.name        = 'lab42_intellihash'
  spec.version     = Lab42::IHash::VERSION
  spec.authors     = ['Robert Dober']
  spec.email       = %w{ robert.dober@gmail.com }
  spec.description = %{A Hash with Business Logic (call it intelligent).}
  spec.summary     = %{An object that upon creation will provide a DSL to specify lookup dependencies, constraints and defaults. When used with
an Hash like object (needs to provide the fetch protocol only, constraints are checked and lookup logic will be executed lazily and cached.}
  spec.homepage    = %{https://github.com/RobertDober/muxoro}
  spec.license     = 'MIT'

  spec.files         = `git ls-files`.split($/)
  spec.test_files    = spec.files.grep(%r{\Atest|\Aspec|\Afeatures|\Ademo/})
  spec.require_paths = %w{lib}

  # spec.post_install_message = %q{ }


  spec.required_ruby_version = '>= 2.0.0'
  spec.required_rubygems_version = '>= 2.2.2'

  spec.add_dependency 'forwarder2', '~> 0.2'

  spec.add_development_dependency 'bundler', '~> 1.6'
  spec.add_development_dependency 'rspec', '~> 2.14'
  spec.add_development_dependency 'pry', '~> 0.9'
  spec.add_development_dependency 'pry-nav', '~> 0.2'
  spec.add_development_dependency 'ae', '~> 1.8'
  spec.add_development_dependency 'qed', '~> 2.9'
  
end
