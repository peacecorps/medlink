class ReceiptsController < ApplicationController
  def edit
    @classifier = ClassifierForm.new
    authorize @classifier
  end

  def update
    classifier = ClassifierForm.new
    authorize classifier
    classifier.update(
      affirmations: params[:receipts][:affirmations],
      negations:    params[:receipts][:negations]
    )
    redirect_back fallback_location: edit_receipts_path, notice: "Settings updated"
  end
end
