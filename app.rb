# Set up for the application and database. DO NOT CHANGE. ###################
require "sinatra"                                                           #
require "sinatra/reloader" if development?                                  #
require "sequel"                                                            #
require "logger"                                                            #
require "twilio-ruby"                                                       #
DB ||= Sequel.connect "sqlite://#{Dir.pwd}/development.sqlite3"             #
DB.loggers << Logger.new($stdout) unless DB.loggers.size > 0                #
def view(template); erb template.to_sym; end                                #
use Rack::Session::Cookie, key: 'rack.session', path: '/', secret: 'secret' #
before { puts "Parameters: #{params}" }                                     #
after { puts; }                                                             #
#############################################################################

events_table = DB.from(:events)
rsvps_table = DB.from(:rsvps)

get "/" do 
puts events_table.all 
@events = events_table.all
view "events"
end 

get "/events/:id" do 
   @event = events_table.where(id: params[:id]).first
   view "event"
end 

get "events/:id/rsvps/new" do 
   @event = events_table.where(id: params[:id]).first
   view "new_rsvp"
end