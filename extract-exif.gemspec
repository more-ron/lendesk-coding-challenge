# Ensure we require the local version and not one we might have installed already
require File.join([File.dirname(__FILE__),'lib','extract-exif','version.rb'])
spec = Gem::Specification.new do |s|
  s.name = 'extract-exif'
  s.version = ExtractExif::VERSION
  s.author = 'More Ron'
  s.email = 'more.ron.too@gmail.com'
  s.homepage = 'https://github.com/more-ron'
  s.platform = Gem::Platform::RUBY
  s.summary = 'EXIF data to CSV extractor'
# Add your other files here if you make them
  s.files = %w(
bin/extract-exif
lib/extract-exif/gps_processor.rb
lib/extract-exif/version.rb
lib/extract-exif.rb
  )
  s.require_paths << 'lib'
  s.bindir = 'bin'
  s.executables << 'extract-exif'
  s.add_development_dependency('rake')
  s.add_development_dependency('rdoc')
  s.add_development_dependency('aruba')
  s.add_development_dependency('test-unit')
  s.add_runtime_dependency('gli','2.5.6')
  s.add_runtime_dependency('exif')
  s.add_runtime_dependency('slim')
end
