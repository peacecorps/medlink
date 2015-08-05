class Admin::MessagesController < AdminController
  def new
    @incoming = SMS.incoming.order(created_at: :desc).first 10
    @outgoing = SMS.outgoing.order(created_at: :desc).first 10

    @bulk = SMS::BulkSender.new
    authorize @bulk, :create?
  end

  def create
    @bulk = SMS::BulkSender.new create_params
    authorize @bulk
    begin
      user_count = @bulk.send!
      flash[:notice] = "Sent messages to #{user_count} users"
      redirect_to :back
    rescue => e
      flash[:danger] = "Error in sending - #{e}"
      redirect_to :back
    end
  end

private

  def create_params
    params.require(:sms_bulk_sender).permit :body, country_ids: []
  end
end
