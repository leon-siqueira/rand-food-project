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

  end
end



def set_params
  @mood = Mood.find(params[:mood]) if params[:mood].present?
  if @mood.nil?
    @tastes = ''
    @radius = 10000
    @min_price = 1
    @max_price = 4
  else
    @tastes = @mood.tastes
    @query = @mood.query
    @radius = @mood.near
    @min_price = @mood.min_price
    @max_price = @mood.max_price
  end
  @limit = 10
  @open_now = 'true'
  @latlong =
  @categories = 13000
  @exclude_chains = true
end
end

@mood.tastes = "sushi, tacos, burger"
@count = @tastes.split.count # 3
@limit = 50 / tastes.split.count

if count == nil?
elsif count == 1
  @limit = 50
elsif count == 2
  @limit = 25
elsif count == 3
  @limit = 20
end

@resultados_organizados = [] # 60 resultados

@tastes.split.each do |taste|
  url = URI("https://api.foursquare.com/v3/places/search?query=#{taste}&ll=#{@latlong}&radius=#{@radius}&categories=#{@categories}&exclude_all_chains=#{@exclude_chains}&fields=name%2Cgeocodes%2Cdistance%2Cdescription%2Ctel%2Cwebsite%2Csocial_media%2Crating%2Cprice%2Ctastes%2Clocation&min_price=#{@min_price}&max_price=#{@max_price}&open_now=#{@open_now}&limit=#{@limit}")
  foursquare_request = URI.open(url, "Authorization" => ENV['FOURSQUARE_KEY']).read
  foursquare_response = JSON.parse(foursquare_request)
  @resultados_organizados = foursquare_response['results']
end

@resultados_organizados.select { |r| r["tastes"].include?(@query) }

@resultados_organizados.sample
