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
        lng: @show_result['geocodes']['main']['longitude']
      }
    ]
  end

  private

  def set_request
    # o site tá quebrando se não há query alguma inserida na barra de pesquisa e o usuário clica search "NoMethodError in Results#index"
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
        lng: result['geocodes']['main']['longitude']
      }
    end
  end

  def set_params
    #@taste_options = ['sushi', 'pizza']
    @tastes = params[:taste]
    @radius = 5000
    @open_now = 'true'
    @latlong =
    @categories = 13000
    @exclude_chains = true
    @min_price = 1
    @max_price = 4
    @limit = 10
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
