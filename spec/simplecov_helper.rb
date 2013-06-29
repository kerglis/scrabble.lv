require 'simplecov'
SimpleCov.start do
  add_filter '/spec/'
  add_filter '/config/'
  add_filter '/app/models/redactor_rails/'
  add_filter '/app/uploaders/'

  add_group 'Models', '/app/models'
  add_group 'Controllers', '/app/controllers'
  add_group 'Helpers', '/app/helpers'
  add_group 'Misc' do |src_file|
    src_file.filename !~ /\/app\/controllers|models|helpers/
  end
end
