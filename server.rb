require "mechanize"
require "sinatra"
require "json"

def fei
  mechanize = Mechanize.new

  page = mechanize.get('http://www.fei.se/nyheter/fei-restaurant-lounge')

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


get '/meatbar' do
  content_type :json, 'charset' => 'utf-8'
  week = meatbar()
  week.to_json
end

get '/fei' do
  content_type :json, 'charset' => 'utf-8'
  week = fei()
  week.to_json
end