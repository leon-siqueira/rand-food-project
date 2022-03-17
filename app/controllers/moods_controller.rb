class MoodsController < ApplicationController
  before_action :set_mood, only: [:show, :edit, :destroy]

  def index
    @moods = Mood.all
  end

  def new
    @mood = Mood.new
  end

  def create
    @mood = Mood.new(mood_params)
    @mood.user_id = current_user.id
    @mood.save
  end

  def destroy
    @mood.destroy
    redirect_to moods_path
  end

  def show
  end

  private

  def set_mood
    @mood = Mood.find(params[:id])
  end

  def mood_params
    params.require(:mood).permit(:name, :query, :near, :min_price, :max_price)
  end
end
