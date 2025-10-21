# app/controllers/schedules_controller.rb
class SchedulesController < ApplicationController
  before_action :authenticate_user!

  load_and_authorize_resource

  def index
    @schedules = (@schedules || Schedule.all)
      .order(starts_at: :asc)

    # Filtros opcionales
    @schedules = @schedules.where(trainer_id: params[:trainer_id]) if params[:trainer_id].present?
    @schedules = @schedules.where(user_id:    params[:user_id])    if params[:user_id].present?
    @schedules = @schedules.where(status:     params[:status])     if params[:status].present?

    if params[:from].present?
      from = time_param(params[:from])
      @schedules = @schedules.where("ends_at > ?", from) if from
    end

    if params[:to].present?
      to = time_param(params[:to])
      @schedules = @schedules.where("starts_at < ?", to) if to
    end

    # Paginación si usas kaminari/will_paginate (opcional)
    @schedules = @schedules.page(params[:page]) if @schedules.respond_to?(:page)

    respond_to do |format|
      format.html
      format.json { render json: @schedules }
    end
  end

  def show
    # con CanCanCan ya tienes @schedule
    respond_to do |format|
      format.html
      format.json { render json: @schedule }
    end
  end

  def new
    @schedule ||= Schedule.new
    # por defecto, el que crea es el "user" (cliente)
    @schedule.user ||= current_user if cannot?(:manage, Schedule)
  end

  def create
    @schedule ||= Schedule.new
    attrs = schedule_params.dup

    # Forzar que el user sea el actual si no tiene permisos globales
    attrs[:user_id] = current_user.id if cannot?(:manage, Schedule)

    @schedule.assign_attributes(attrs)

    if @schedule.save
      respond_to do |format|
        format.html { redirect_to @schedule, notice: "Horario creado correctamente." }
        format.json { render json: @schedule, status: :created }
      end
    else
      respond_to do |format|
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: { errors: @schedule.errors }, status: :unprocessable_entity }
      end
    end
  rescue ActiveRecord::StatementInvalid => e
    if exclusion_violation?(e)
      @schedule.errors.add(:base, "Este horario se solapa con otro del mismo entrenador.")
      render :new, status: :unprocessable_entity
    else
      raise
    end
  end

  def edit; end

  def update
    attrs = schedule_params.dup
    attrs[:user_id] = current_user.id if cannot?(:manage, Schedule)

    if @schedule.update(attrs)
      respond_to do |format|
        format.html { redirect_to @schedule, notice: "Horario actualizado." }
        format.json { render json: @schedule }
      end
    else
      respond_to do |format|
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: { errors: @schedule.errors }, status: :unprocessable_entity }
      end
    end
  rescue ActiveRecord::StatementInvalid => e
    if exclusion_violation?(e)
      @schedule.errors.add(:base, "Este horario se solapa con otro del mismo entrenador.")
      render :edit, status: :unprocessable_entity
    else
      raise
    end
  end

  def destroy
    @schedule.destroy
    respond_to do |format|
      format.html { redirect_to schedules_path, notice: "Horario eliminado." }
      format.json { head :no_content }
    end
  end

  private


  def schedule_params
    params.require(:schedule).permit(
      :user_id, :trainer_id, :starts_at, :ends_at, :status,
      :location, :notes, :price_cents
    )
  end

  def time_param(value)
    return if value.blank?
    Time.zone.parse(value) rescue nil
  end

  def exclusion_violation?(error)
    klass = defined?(PG::ExclusionViolation) ? PG::ExclusionViolation : nil
    cause = error.cause
    (klass && cause.is_a?(klass)) ||
      (cause && cause.class.name.include?("ExclusionViolation")) ||
      error.message.match?(/exclusion|no_overlapping_trainer_slots|&&/i)
  end
end
