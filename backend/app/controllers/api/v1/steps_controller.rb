class Api::V1::StepsController < Api::V1::BaseController
  def index
    quest = Quest.find(params[:quest_id])
    steps = quest.steps.order(:position)
    render json: steps
  end
end
