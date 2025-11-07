class GamesController < ApplicationController
  before_action :set_game, only: %i[ show edit update destroy ]

  def index
    @games = Game.order(created_at: :desc)
  end

  def roulette
    @games = Game.all
  end

  def show
  end

  def new
    @game = Game.new
  end

  def edit
  end

  def create
    @game = Game.new(game_params)
    if @game.save
      redirect_to @game, notice: "Juego creado correctamente."
    else
      flash.now[:alert] = "Revisa los campos."
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @game.update(game_params)
      redirect_to @game, notice: "Juego actualizado."
    else
      flash.now[:alert] = "Revisa los campos."
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @game.destroy
    redirect_to games_url, notice: "Juego eliminado."
  end

  private

  def set_game
    @game = Game.find(params[:id])
  end

  def game_params
    params.require(:game).permit(:name, :objective, :description, :photo)
  end
end
