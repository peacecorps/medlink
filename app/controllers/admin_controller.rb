class AdminController < ApplicationController
  before_action do
    authorize :admin, :manage?
  end
end
