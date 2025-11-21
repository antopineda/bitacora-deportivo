class ReflectionsController < ApplicationController
  before_action :set_reflection, only: [:show, :edit, :update, :destroy]

  # GET /reflections
  def index
    @reflections = Reflection.all.order(created_at: :desc)
  end

  # GET /reflections/:id
  def show
  end

  # GET /reflections/new
  def new
    @reflection = Reflection.new
  end

  # GET /reflections/:id/edit
  def edit
  end

  # POST /reflections
  def create
    @reflection = Reflection.new(reflection_params)

    if @reflection.save
      redirect_to @reflection, notice: "La reflexión se creó exitosamente."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /reflections/:id
  def update
    if @reflection.update(reflection_params)
      redirect_to @reflection, notice: "La reflexión se actualizó exitosamente."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /reflections/:id
  def destroy
    @reflection.destroy
    redirect_to reflections_url, notice: "La reflexión se eliminó exitosamente."
  end

  private

  def set_reflection
    @reflection = Reflection.find(params[:id])
  end

  def reflection_params
    params.require(:reflection).permit(:name, :reflection, :profile_photo)
  end
end
