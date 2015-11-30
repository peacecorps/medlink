class RostersController < ApplicationController
  def show
    roster = Roster.new country: current_user.country, rows: current_user.country.users.non_admins
    authorize roster
    @users = sort_table roster.rows.includes(:phones), per_page: 25, presenter: RosterUserPresenter
  end

  def upload
    upload = current_user.roster_uploads.new \
      body: params[:roster][:csv].read, country: current_user.country
    authorize upload, :create?
    upload.save!
    redirect_to edit_country_roster_path(upload_id: upload.id)
  end

  def edit
    upload  = current_user.country.roster_uploads.find params[:upload_id]
    @roster = RosterForm.new upload.roster
    authorize @roster
    @roster.validate({})
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
end
