require 'erb'

# Monkeypatch ConfigFile until this PR is shipped in a sinatra-contrib release.
# https://github.com/sinatra/sinatra-contrib/pull/54
module Sinatra::ConfigFile
  def config_file(*paths)
    Dir.chdir(root || '.') do
      paths.each do |pattern|
        Dir.glob(pattern) do |file|
          $stderr.puts "loading config file '#{file}'" if logging?
          document = IO.read(file)
          document = ERB.new(document).result if file.split('.').include?('erb')
          yaml = config_for_env(YAML.load(document)) || {}
          yaml.each_pair do |key, value|
            for_env = config_for_env(value)
            set key, for_env unless value and for_env.nil? and respond_to? key
          end
        end
      end
    end
  end
end
