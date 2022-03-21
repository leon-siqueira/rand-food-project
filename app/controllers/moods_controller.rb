class MoodsController < ApplicationController
  before_action :set_mood, only: [:show, :edit, :update, :destroy]

  def index
    @moods = current_user.moods.all
  end

  def new
    @mood = Mood.new
  end

  def create
    @mood = Mood.new(mood_params)
    @mood.user_id = current_user.id
    if @mood.save
      redirect_to moods_path, notice: "Mood was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    if @mood.user_id == current_user.id
      @mood.destroy
      redirect_to moods_path, notice: "Mood was successfully deleted."
    end
  end

  def show
  end

  def edit
  end

  def update
    if @mood.update(mood_params)
      redirect_to moods_path, notice: "Mood was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_mood
    @mood = Mood.find(params[:id])
    redirect_to root_path if @mood.user_id != current_user.id
  end

  def mood_params
    params.require(:mood).permit(:name, :query, :near, :min_price, :max_price, tastes: [])
  end
end
