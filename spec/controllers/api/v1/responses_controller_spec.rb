require "rails_helper"

RSpec.describe Api::V1::ResponsesController do
  Given(:response) { create :response }

  context "marking my response" do
    As { response.user }

    context "marking my response received" do
      When { post :mark_received, params: { id: response.id } }

      Then { status == 200             }
      And  { response.reload.received? }
    end

    context "flagging my response" do
      When { post :flag, params: { id: response.id } }

      Then { status == 200            }
      And  { response.reload.flagged? }
    end
  end

  context "marking someone else's response" do
    As { pcv }

    context "marking my response received" do
      When { post :mark_received, params: { id: response.id } }

      Then { status == 403              }
      And  { !response.reload.received? }
    end

    context "flagging my response" do
      When { post :flag, params: { id: response.id } }

      Then { status == 403             }
      And  { !response.reload.flagged? }
    end
  end
end
