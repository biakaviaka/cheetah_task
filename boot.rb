require 'socket'
require 'yaml'
require 'sequel'
require 'csv'
require 'json'


Sequel.extension :migration, :core_extensions

#read .yaml config and create connection
db_config_file = File.join(File.dirname(__FILE__), 'db', "database.yml")
if File.exist?(db_config_file)
  config = YAML.load(File.read(db_config_file))
  DB = Sequel.connect(config)
end

if DB
  Sequel::Migrator.run(DB, File.join(File.dirname(__FILE__), 'db', 'migrate'))
end

#load all files from ./config  dir
Dir[File.join(File.dirname(__FILE__), 'config', '**', '*.rb')].each {|file| require file }

#load all files from ./lib  dir
Dir[File.join(File.dirname(__FILE__), 'lib', '**', '*.rb')].each {|file| require file }

#load all files from ./models  dir
Dir[File.join(File.dirname(__FILE__), 'models', '**', '*.rb')].each {|file| require file }
