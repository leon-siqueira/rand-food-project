class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :home ]
  before_action :set_moods, only: [:home]
  def home
  end

  def about
  end
  
  private

  def set_moods
    @moods = current_user ? Mood.where(user: [current_user, nil]) : Mood.where(user: nil)
  end
end
