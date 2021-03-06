require "mechanize"
require "sinatra"
require "json"

require "dalli"
require "rack-cache"

def fei
  mechanize = Mechanize.new
  #redis = Redis.new

  page = mechanize.get('http://www.fei.se/nyheter/fei-restaurant-lounge')

  # redis.set("fei", page)
  # redis.expire(:fei, 3600*24)

  # if redis.get("fei")
  #   p redis[:fei]
  # end

  week = []
  weekday = []
  page.search('.section.page p').each_with_index do |node, index|
    if index % 3 == 0
      week[index/3] = weekday
      weekday = []
    else
      weekday.push node.text.strip
    end
  end

  week.shift #remove junk
  week.pop #remove non-food
  week
end

def meatbar
  mechanize = Mechanize.new

  page = mechanize.get('http://kottbaren.se/meny/lunch/')

  week = []
  #weekday = []
  page.search('.postText p').each_with_index do |node, index|
    node_text = node.text.strip

    new_line_index = node_text.index(/\n/)
    if new_line_index # no new-line => no food
      week.push [node_text[new_line_index + 1, node_text.length]]
    end
  end

  week
end

def grill
  mechanize = Mechanize.new

  page = mechanize.get('http://grill.se/en/lunch/')

  week = []
  
  page.search('.entry-content p').each_with_index do |node, index|
    node_text = node.text.strip

    #new_line_index = node_text.index(/\:/)
    #if new_line_index # no new-line => no food
      
      #new_line_index = node_text.index(/\:/)
      weekday =  node_text.split(/\n/)
      weekday.map! do |dish| 
          dish_name = dish.split(/\:/)[1] #remove Fisk: yada-yada
          dish_name.strip if(dish_name)
      end
      
      weekday.shift
      week.push weekday
    #end
  end

  week.shift
  week.pop
  week.shift
  week
end

def vendelas
  mechanize = Mechanize.new

  page = mechanize.get('http://vendelas.kvartersmenyn.se/')

  week = []
  
  page.search('br').each do |n|
    n.replace("\n")
  end

  node = page.search('.menyn div')[1] #this is the menu-node

    week = node.text.split(/\n/)
    .reject { |n| n.empty? }.each_slice(4).to_a


  week.map! do |day| 
      day[1,day.length] #remove weekday
  end

  week
end

set :public_folder, File.dirname(__FILE__) + '/public'


get '/' do
  erb :index
end

get '/all' do
  cache_control :public, max_age: 86400 
  content_type :json, 'charset' => 'utf-8'
  week = {}
  week[:fei] = fei()
  week[:grill] = grill()
  week[:meatbar] = meatbar()
  week[:vendelas] = vendelas()
  week.to_json
end

get '/meatbar' do
  cache_control :public, max_age: 86400 
  content_type :json, 'charset' => 'utf-8'
  week = meatbar()
  week.to_json
end

get '/vendelas' do
  cache_control :public, max_age: 86400 
  content_type :json, 'charset' => 'utf-8'
  week = vendelas()
  week.to_json
end

get '/grill' do
  p "========="
  cache_control :public, max_age: 86400 
  content_type :json, 'charset' => 'utf-8'
  week = grill()
  week.to_json
end

get '/fei' do
  cache_control :public, max_age: 86400 
  content_type :json, 'charset' => 'utf-8'
  week = fei()
  week.to_json
end