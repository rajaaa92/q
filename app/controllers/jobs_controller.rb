class JobsController < ApplicationController

  def new
  end

  def order
    @jobs = JobsOrderer.new(params[:jobs]).perform
    render json: {data: @jobs}
  rescue JobsError => e
    render json: {error: e.message}, status: 400
  end
end
