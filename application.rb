require 'rubygems'
require 'pusher'
require 'mongo_mapper'
require 'haml'
require 'sinatra'

configure do
  MongoMapper.connection = Mongo::Connection.new(ENV['MONGOHQ_URL'])
  MongoMapper.database = "pusher_fun"

  Pusher.app_id = '1786'
  Pusher.key = '09435da909450e9b4b6e'
  Pusher.secret = '6112f12f27007eaab27d'

  APP_ID = Pusher.app_id
  API_KEY = Pusher.key
  SECRET = Pusher.secret
end

class Message
  include MongoMapper::Document
  key :screen_name, String, :required => true
  key :message, String, :required => true
end

get '/' do
  @messages = Message.all
  haml(:index)
end

post '/messages/?' do
  @screen_name = params[:screen_name]
  @message = params[:message]
  Pusher['test_channel'].trigger('my_event', "#{@screen_name} said: #{@message}")
  message = Message.create({:screen_name => @screen_name, :message => @message})
  message.save
end
