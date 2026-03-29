class Api::V1::QuestsController < Api::V1::BaseController
  def index
    quests = Quest.all.order(:priority)
    render json: quests
  end

  def show
    quest = Quest.find(params[:id])
    render json: quest.as_json(include: :steps)
  end
end
