class Api::V1::UserStepsController < Api::V1::BaseController
  def create
    step = Step.find(params[:step_id])

    if current_user.user_steps.exists?(step: step)
      render json: { error: "Step already completed" }, status: :unprocessable_entity
      return
    end

    user_step = current_user.user_steps.create!(
      step: step,
      completed: true,
      completed_at: Time.current
    )

    render json: user_step, status: :created
  end
end
