lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |s| 

  s.authors = ["niebuyun"]
  s.email = ["835482737@qq.com"]
  s.homepage = "https://github.com/nbyun/rack-gridfs-new"
  s.licenses = ['MIT']

  s.name = 'rack-gridfs-new'
  s.version = Rack::GridFSNEW::VERSION

  s.platform = Gem::Platform::RUBY
  s.files = `git ls-files`.split("\n").sort
  s.require_paths = ['lib']

  s.add_dependency('rack', '>= 1.0')
  s.add_dependency('mongo', '~> 2.0')

end