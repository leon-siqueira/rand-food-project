require 'uri'
require 'net/http'
require "open-uri"

class ResultsController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :home ]
  before_action :set_params

  def index
    set_request
  end

  def show
    set_request
    @show_result = @results.sample
    @markers = [
      {
        lat: @show_result['geocodes']['main']['latitude'],
        lng: @show_result['geocodes']['main']['longitude'],
        info_window: render_to_string(partial: "info_window", locals: { name: @show_result["name"], rating: @show_result["rating"] })
      }
    ]
  end

  private

  def set_request
    if params[:query].present?
      if params[:query].count("a-zA-Z") > 0
        results = Geocoder.search(params[:query])
        @latlong = "#{results.first.coordinates[0]},#{results.first.coordinates[1]}"
      else
        @latlong = params[:query]
      end
      url = URI("https://api.foursquare.com/v3/places/search?query=#{@tastes}&ll=#{@latlong}&radius=#{@radius}&categories=#{@categories}&exclude_all_chains=#{@exclude_chains}&fields=name%2Cgeocodes%2Cdistance%2Cdescription%2Ctel%2Cwebsite%2Csocial_media%2Crating%2Cprice%2Ctastes%2Clocation&min_price=#{@min_price}&max_price=#{@max_price}&open_now=#{@open_now}&limit=#{@limit}")
      foursquare_request = URI.open(url, "Authorization" => ENV['FOURSQUARE_KEY']).read
      foursquare_response = JSON.parse(foursquare_request)
      @results = foursquare_response['results']
      @results = @results.sort_by { |result| result["geocodes"]["main"]["latitude"] }
      set_markers
    else
      redirect_to root_path
    end
  end

  def set_markers
    @markers = @results.map do |result|
      {
        lat: result['geocodes']['main']['latitude'],
        lng: result['geocodes']['main']['longitude'],
        info_window: render_to_string(partial: "info_window", locals: { name: result["name"], rating: result["rating"] })
      }
    end
  end

  def set_params
    @mood = Mood.find(params[:mood])

    @tastes = @mood.tastes.gsub(' ', '%20').gsub(',', '%2C')
    @query = @mood.query
    @radius = @mood.near
    @min_price = @mood.min_price
    @max_price = @mood.max_price

    @limit = 10
    @open_now = 'true'
    @latlong =
    @categories = 13000
    @exclude_chains = true

    # %20 = espaço, %2C = virgula
    # Tastes detalhados pelo usuário - tacos, good for groups, romantic, sushi, good for late nights, live music.
    #raio de busca de restaurantes - padrão pode ser 5km
    #open_now = true(padrão)
    #categories = 13000 por padrão (13000 referente a restaurantes e bares)
    #exclude_all_chains - excluir grandes redes de restaurantes (true or false)
    #minprice = valor de 1 até 4
    #maxprice = valor de 1 até 4
    #limit = limite de resultados - max 50 min 1 // teste = 5
  end
end
