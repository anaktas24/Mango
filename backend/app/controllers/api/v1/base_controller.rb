class Api::V1::BaseController < ApplicationController
  before_action :authenticate_user!

  private

  def current_user
    super
  end
end
