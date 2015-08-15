class RequestsController < ApplicationController
  # TODO: figure out why the @#!% update is causing an n+1 in update_watching!
  # Hypothesis: it has something to do with the UserScope magic
  around_action :skip_bullet, only: [:create], if: -> { Rails.env.test? }

  def new
    @request = Request.new entered_by: current_user.id
    authorize @request
  end

  def create
    rc = RequestCreator.new current_user, params
    authorize rc.request

    if rc.save
      redirect_to after_create_path, flash: { success: rc.success_message }
    else
      @request = rc.request
      flash.now[:error] = rc.error_message
      render :new
    end
  end

  def mark_received
    @request = Request.find params[:id]
    authorize @request
    @request.orders.each &:mark_received!
    # FIXME: this is gross, but we should be bulk-marking _responses_ not requests anyways
    Response.
      where(id: @request.orders.pluck(:response_id).uniq.compact, archived_at: nil).
      includes(:orders).
      each &:check_for_completion!
    redirect_to :back
  end

  def flag
    @request = Request.find params[:id]
    authorize @request
    @request.orders.each &:flag!
    redirect_to :back
  end

private

  def after_create_path
    if current_user.admin?
      new_admin_user_path
    elsif current_user.pcmo?
      manage_orders_path
    else
      orders_path
    end
  end
end
