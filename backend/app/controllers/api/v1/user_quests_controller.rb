class Api::V1::UserQuestsController < Api::V1::BaseController
  def index
    user_quests = current_user.user_quests.includes(:quest).order(:position)
    render json: user_quests.as_json(include: :quest)
  end

  def create
    quest = Quest.find(params[:quest_id])

    if current_user.user_quests.exists?(quest: quest)
      render json: { error: "Quest already started" }, status: :unprocessable_entity
      return
    end

    user_quest = current_user.user_quests.create!(
      quest: quest,
      status: :in_progress,
      position: current_user.user_quests.count + 1
    )

    render json: user_quest, status: :created
  end
end
