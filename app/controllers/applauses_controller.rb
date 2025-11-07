class ApplausesController < ApplicationController
  before_action :set_applause, only: %i[ show edit update destroy ]

  def index
    @applauses = Applause.order(created_at: :desc)
  end

  def show
  end

  def new
    @applause = Applause.new
  end

  def edit
  end

  def create
    @applause = Applause.new(applause_params)
    if @applause.save
      redirect_to @applause, notice: "Aplauso creado correctamente."
    else
      flash.now[:alert] = "Revisa los campos."
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @applause.update(applause_params)
      redirect_to @applause, notice: "Aplauso actualizado."
    else
      flash.now[:alert] = "Revisa los campos."
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @applause.destroy
    redirect_to applauses_url, notice: "Aplauso eliminado."
  end

  private

  def set_applause
    @applause = Applause.find(params[:id])
  end

  def applause_params
    params.require(:applause).permit(:name, :objective, :description, :photo)
  end
end
