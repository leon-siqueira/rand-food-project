class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :home ]

  def home
    if params[:query].present?
      results = Geocoder.search(params[:query])
      results.first.coordinates
      raise
    end

  end
end
