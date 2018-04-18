require './app'
run Sinatra::Application

$stdout.sync = true #To take advantage of the real-time logging, you may need to disable any log buffering your application may be carrying out. For example, in Ruby, add this to your config.ru:
