module Federails
  class InstallGenerator < Rails::Generators::Base
    source_root File.expand_path('templates', __dir__)

    def copy_files
      copy_file 'federails.yml', 'config/federails.yml'
      copy_file 'federails.rb', 'config/initializers/federails.rb'
    end
  end
end
