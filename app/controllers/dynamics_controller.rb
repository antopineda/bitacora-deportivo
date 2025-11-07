class DynamicsController < ApplicationController
  before_action :set_dynamic, only: %i[ show edit update destroy ]

  def index
    @dynamics = Dynamic.order(created_at: :desc)
  end

  def show
  end

  def new
    @dynamic = Dynamic.new
  end

  def edit
  end

  def create
    @dynamic = Dynamic.new(dynamic_params)
    if @dynamic.save
      redirect_to @dynamic, notice: "Dinámica creada correctamente."
    else
      flash.now[:alert] = "Revisa los campos."
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @dynamic.update(dynamic_params)
      redirect_to @dynamic, notice: "Dinámica actualizada."
    else
      flash.now[:alert] = "Revisa los campos."
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @dynamic.destroy
    redirect_to dynamics_url, notice: "Dinámica eliminada."
  end

  private

  def set_dynamic
    @dynamic = Dynamic.find(params[:id])
  end

  def dynamic_params
    params.require(:dynamic).permit(:name, :objective, :description, :photo)
  end
end
