require 'uri'
require 'net/http'
#require 'openssl'
require "open-uri"

class ResultsController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :home ]
  before_action :set_request

  def index
    @results
  end

  def show
    @show_result = @results.sample
  end

  private

  def set_request
    # OPEN URI
    url = "https://api.foursquare.com/v3/places/search?ll=#{$latlong}&fields=name&limit=5"
    foursquare_request = URI.open(url, "Authorization" => ENV['FOURSQUARE_KEY']).read
    foursquare_response = JSON.parse(foursquare_request)
    @results = foursquare_response['results']

    # OPEN SSL
    # url = URI("https://api.foursquare.com/v3/places/search?ll=#{$latlong}&fields=name&limit=5")
    # http = Net::HTTP.new(url.host, url.port)
    # http.use_ssl = true
    # request = Net::HTTP::Get.new(url)
    # request["Accept"] = 'application/json'
    # request["Authorization"] = ENV['FOURSQUARE_KEY']
    # response = http.request(request)
    # @foursquare_response = response.read_body
  end
end

# URL https://api.foursquare.com/v3/places/search?query=#{query}&ll=#{latitude}%2C-#{longitude}&radius=#{radius}&categories=13000&fields=#{fields}&min_price=#{minprice}&max_price=#{maxprice}&open_now=#{open_now}&sort=#{sortby}&limit=#{result_limit}

# Tastes detalhados pelo usuário - tacos, good for groups, romantic, sushi, good for late nights, live music.
# query = @query

#latitude
# latitude = @latlong

#raio de busca de restaurantes - padrão pode ser 5km
# radius = @radius

#exclude_all_chains - excluir grandes redes de restaurantes (true or false)
# exclude_chains = @exclude_chains

#categories = 13000 por padrão (13000 referente a restaurantes e bares)

#minprice = valor de 1 até 4
# minprice = @minprice

#maxprice = valor de 1 até 4
# maxprice = @maxprice

#open_now = true(padrão)
# open_now = @open_now

#sortby = relevance(padrão), rating, distance

#limit = limite de resultados - max 50 min 1 // teste = 5
# limit = @limit
