require 'uri'
require 'net/http'
require "open-uri"

class ResultsController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :home, :index, :show ]
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
    @results_pool = []
    if @tastes.count.zero?
      set_categories
      url = URI("https://api.foursquare.com/v3/places/search?&ll=#{@latlong}&radius=#{@radius}&categories=#{@categories}&exclude_all_chains=#{@exclude_chains}&fields=name%2Cgeocodes%2Cdistance%2Cdescription%2Ctel%2Cwebsite%2Csocial_media%2Crating%2Cprice%2Ctastes%2Clocation&min_price=#{@min_price}&max_price=#{@max_price}&open_now=#{@open_now}&limit=#{@limit}")
      foursquare_request = URI.open(url, "Authorization" => ENV['FOURSQUARE_KEY']).read
      foursquare_response = JSON.parse(foursquare_request)
      response = foursquare_response['results']
      response.each { |r| @results_pool << r }
    else
      @tastes.each do |taste|
        if taste.include?("asian")
          @categories = 13_072
        elsif taste.include?("sushi")
          @categories = 13_263
        elsif taste.include?("pizza")
          @categories = 13_064
        elsif taste.include?("burger")
          @categories = 13_031
        else
          @categories = 13_000
        end
        url = URI("https://api.foursquare.com/v3/places/search?query=#{taste}&ll=#{@latlong}&radius=#{@radius}&categories=#{@categories}&exclude_all_chains=#{@exclude_chains}&fields=name%2Cgeocodes%2Cdistance%2Cdescription%2Ctel%2Cwebsite%2Csocial_media%2Crating%2Cprice%2Ctastes%2Clocation&min_price=#{@min_price}&max_price=#{@max_price}&open_now=#{@open_now}&limit=#{@limit}")
        foursquare_request = URI.open(url, "Authorization" => ENV['FOURSQUARE_KEY']).read
        foursquare_response = JSON.parse(foursquare_request)
        response = foursquare_response['results']
        response.each { |r| @results_pool << r }
      end
    end
    result_filter
    set_markers
  end

  def result_filter
    @final_results = []
    # @final_results << @results_pool.select { |r| r["tastes"].include?(@query) }
    @results_pool.each do |result|
      @final_results << result if result['tastes']&.include?(@query)
    end
    @query == "" ? @results = @results_pool : @results = @final_results
  end

  def set_markers
    @results = @results.sort_by { |result| result["geocodes"]["main"]["latitude"] }
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
      @tastes = []
      @radius = 5000
      @min_price = 1
      @max_price = 4
    else
      @tastes = @mood.tastes.map { |t| t.gsub(' ', '%20') }
      @query = @mood.query
      if @mood.near.to_i < 1000 ? @radius = 5000 : @radius = @mood.near.to_i
      @min_price = @mood.min_price
      @max_price = @mood.max_price
    end
  end
    @mood.present? ? set_limit : @limit = 10
    @categories = 13_000
    @open_now = 'true'
    @exclude_chains = true
  end

  def set_limit
    count = 1
    @mood.tastes.count.zero? ? count : count = @mood.tastes.count
    @limit = 30 / count
  end
end

# def set_categories
#   if @taste.include?("asian")
#     @categories = 13_072
#   elsif @mood.tastes.include?("sushi")
#     @categories = 13_263
#   elsif @mood.tastes.include?("burger")
#     @categories = 13_031
#   elsif @mood.tastes.include?("pizza")
#     @categories = 13_064
#   else
#     @categories = 13_000
#   end

  def set_categories
    if taste.include?("asian")
      @categories = 13_072
    elsif taste.include?("sushi")
      @categories = 13_263
    elsif taste.include?("pizza")
      @categories = 13_064
    elsif taste.include?("burger")
      @categories = 13_031
    else
      @categories = 13_000
    end
  end
