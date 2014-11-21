ENV['RACK_ENV'] = 'test'
require 'minitest/autorun'
require 'rack/test'
require_relative 'server.rb'
 
include Rack::Test::Methods
 
def app
  Sinatra::Application
end

describe "LunchScraper" do

  describe "Fei" do
    
    it "should return array with menu" do
      assert fei.count.must_equal 5
    end

    it "should return json" do
      get '/fei'
      last_response.headers['Content-Type'].must_equal 'application/json;charset=utf-8'
    end

  describe "Grill" do
    
    it "should return array with menu" do
      assert grill.count.must_equal 5
    end

    it "should return json" do
      get '/grill'
      last_response.headers['Content-Type'].must_equal 'application/json;charset=utf-8'
    end
  end

  describe "Meatbar" do
    
    it "should return array with menu" do
      assert meatbar.count.must_equal 5
    end

    it "should return json" do
      get '/meatbar'
      last_response.headers['Content-Type'].must_equal 'application/json;charset=utf-8'
    end
  end

  describe "Vendelas" do
    
    it "should return array with menu" do
      assert vendelas.count.must_equal 5
    end

    it "should return json" do
      get '/vendelas'
      last_response.headers['Content-Type'].must_equal 'application/json;charset=utf-8'
    end
  end


  end
end