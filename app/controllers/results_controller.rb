require 'uri'
require 'net/http'
require "open-uri"

class ResultsController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :home ]
  before_action :set_params

  def index
    set_geocode
  end

  def show
    set_geocode
    set_request
    @show_result = @results.sample
    unless @show_result.nil?
      @markers = [
        {
          lat: @show_result['geocodes']['main']['latitude'],
          lng: @show_result['geocodes']['main']['longitude'],
          info_window: render_to_string(partial: "info_window", locals: { name: @show_result["name"], price: @show_result["price"], rating: @show_result["rating"] }),
          image_url: helpers.asset_url("orange-pin.svg")
        }
      ]
    end
  end

  private

  def set_geocode
    if params[:query].present?
      if params[:query].count("a-zA-Z") > 0
        results = Geocoder.search(params[:query])
        @latlong = "#{results.first.coordinates[0]},#{results.first.coordinates[1]}"
      else
        @latlong = params[:query]
      end
      set_request
    else
      redirect_to root_path
    end
  end

  def set_request
      url = URI("https://api.foursquare.com/v3/places/search?query=#{@tastes}&ll=#{@latlong}&radius=#{@radius}&categories=#{@categories}&exclude_all_chains=#{@exclude_chains}&fields=name%2Cgeocodes%2Cdistance%2Cdescription%2Ctel%2Cwebsite%2Csocial_media%2Crating%2Cprice%2Ctastes%2Clocation&min_price=#{@min_price}&max_price=#{@max_price}&open_now=#{@open_now}&limit=#{@limit}")
      foursquare_request = URI.open(url, "Authorization" => ENV['FOURSQUARE_KEY']).read
      foursquare_response = JSON.parse(foursquare_request)
      @results = foursquare_response['results']
      @results = @results.sort_by { |result| result["geocodes"]["main"]["latitude"] }
      set_markers
  end

  def set_markers
    @markers = @results.map do |result|
      {
        lat: result['geocodes']['main']['latitude'],
        lng: result['geocodes']['main']['longitude'],
        info_window: render_to_string(partial: "info_window", locals: { name: result["name"], rating: result["rating"] }),
        image_url: helpers.asset_url("orange-pin.svg")
      }
    end
  end

  def set_params
    @mood = Mood.find(params[:mood]) if params[:mood].present?
    if @mood.nil?
      @tastes = ''
      @radius = 5000
      @min_price = 1
      @max_price = 4
    else
      @tastes = @mood.tastes.join #.gsub(' ', '%20').gsub(',', '%2C')
      @query = @mood.query
      @mood.near.to_i < 1 ? @radius = 5000 : @radius = @mood.near.to_i
      @min_price = @mood.min_price
      @max_price = @mood.max_price
    end
    @limit = 10
    @open_now = 'true'
    @latlong = ''
    @categories = 13_000
    @exclude_chains = true
  end
end

# def set_params
#   @mood = Mood.find(params[:mood]) if params[:mood].present?
#   if @mood.nil?
#     @tastes = ''
#     @radius = 10000
#     @min_price = 1
#     @max_price = 4
#   else
#     @tastes = @mood.tastes
#     @query = @mood.query
#     @radius = @mood.near
#     @min_price = @mood.min_price
#     @max_price = @mood.max_price
#   end
#   @limit = 10
#   @open_now = 'true'
#   @latlong =
#   @categories = 13000
#   @exclude_chains = true
# end
# end

# @mood.tastes = "sushi, tacos, burger" #ATÉ 3
# @mood.query = "romantic"  # SOMENTE 1
# @count = @mood.tastes.split.count # 3
# @limit = 50 / count

# if count == nil?
# elsif count == 1
#   @limit = 50
# elsif count == 2
#   @limit = 25
# elsif count == 3
#   @limit = 20
# end

# resultados_organizados = [] # 60 resultados

# @tastes.split.each do |taste|
#   url = URI("https://api.foursquare.com/v3/places/search?query=#{taste}&ll=#{@latlong}&radius=#{@radius}&categories=#{@categories}&exclude_all_chains=#{@exclude_chains}&fields=name%2Cgeocodes%2Cdistance%2Cdescription%2Ctel%2Cwebsite%2Csocial_media%2Crating%2Cprice%2Ctastes%2Clocation&min_price=#{@min_price}&max_price=#{@max_price}&open_now=#{@open_now}&limit=#{@limit}")
#   foursquare_request = URI.open(url, "Authorization" => ENV['FOURSQUARE_KEY']).read
#   foursquare_response = JSON.parse(foursquare_request)
#   @resultados_organizados = foursquare_response['results']
# end

# @resultados_final = resultados_organizados.select { |r| r["tastes"].include?(@query) }

# @resultados_organizados.sample
