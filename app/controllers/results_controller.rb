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
          image_url: helpers.asset_url("orange-pin.png")
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
    if @tastes.empty?
      url = URI("https://api.foursquare.com/v3/places/search?query=#{}&ll=#{@latlong}&radius=#{@radius}&categories=#{@categories}&exclude_all_chains=#{@exclude_chains}&fields=name%2Cgeocodes%2Cdistance%2Cdescription%2Ctel%2Cwebsite%2Csocial_media%2Crating%2Cprice%2Ctastes%2Clocation&min_price=#{@min_price}&max_price=#{@max_price}&open_now=#{@open_now}&limit=#{@limit}")
      foursquare_request = URI.open(url, "Authorization" => ENV['FOURSQUARE_KEY']).read
      foursquare_response = JSON.parse(foursquare_request)
      response = foursquare_response['results']
      response.each { |r| @results_pool << r }
    elsif
      @tastes.each do |taste|
        if taste.include?("Asian")
          @categories = 13_072
        elsif taste.include?("Sushi")
          @categories = 13_263
        elsif taste.include?("Pizza")
          @categories = 13_064
        elsif taste.include?("Burger")
          @categories = 13_031
        elsif taste.include?("Vegan")
          @categories = 13_377
        elsif taste.include?("Seafood")
          @categories = 13_338
        elsif taste.include?("Wine")
          @categories = 13_025
        elsif taste.include?("Mexican")
          @categories = 13_303
        elsif taste.include?("Peruvian")
          @categories = 13_322
        elsif taste.include?("Italian")
          @categories = 13_236
        elsif taste.include?("Brazilian")
          @categories = 13_079
        elsif taste.include?("French")
          @categories = 13_148
        elsif taste.include?("Argentinian")
          @categories = 13_070
        elsif taste.include?("BBQ")
          @categories = 13_026
        elsif taste.include?("Comfort")
          @categories = 13_134
        elsif taste.include?("Coffee")
          @categories = 13_032
        elsif taste.include?("Desserts")
          @categories = 13_040
        elsif taste.include?("Chinese")
          @categories = 13_099
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
        image_url: helpers.asset_url("orange-pin.png")
      }
    end
  end

  def set_params
    @mood = Mood.find(params[:mood]) if params[:mood].present?
    if @mood.nil?
      @tastes = []
      @query = ""
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
    @mood.present? ? set_limit : @limit = 20
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

  def set_categories
    if @tastes.include?("asian")
      @categories = 13_072
    elsif @tastes.include?("sushi")
      @categories = 13_263
    elsif @tastes.include?("pizza")
      @categories = 13_064
    elsif @tastes.include?("burger")
      @categories = 13_031
    else
      @categories = 13_000
    end
  end
