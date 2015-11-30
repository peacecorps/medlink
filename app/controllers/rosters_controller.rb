class RostersController < ApplicationController
  def show
    roster = Roster.new country: current_user.country, rows: current_user.country.users.non_admins
    authorize roster
    @users = sort_table do |t|
      t.scope     = roster.rows.includes(:phones)
      t.per_page  = 25
      t.presenter = RosterUserPresenter
    end
  end

  def upload
    upload = current_user.roster_uploads.new \
      uri: params[:file], country: current_user.country
    authorize upload, :create?
    upload.save! validate: false
    RosterUploadFetchJob.perform_later upload
    render json: { status: :ok, upload_id: upload.id }
  end

  def edit
    upload = current_user.country.roster_uploads.find params[:upload_id]
    if upload.fetched?
      @roster = RosterForm.new upload.roster
      authorize @roster
      @roster.validate({})
    else
      authorize upload, :poll?
      render :poll
    end
  end

  def update
    upload  = current_user.country.roster_uploads.find params[:upload_id]
    @roster = RosterForm.new upload.roster
    if save_form @roster, rows: params[:roster][:rows_attributes].values
      redirect_to country_roster_path
    else
      render :edit
    end
  end

  def poll
    upload = current_user.roster_uploads.find params[:upload_id]
    authorize upload
    render json: { ready: upload.body.present? }
  end
end
