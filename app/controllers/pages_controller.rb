class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :home ]

  def home
    if params[:query].present?
      results = Geocoder.search(params[:query])
      $latlong = "#{results.first.coordinates[0]},#{results.first.coordinates[1]}"
      redirect_to results_path
    end
  end

end
