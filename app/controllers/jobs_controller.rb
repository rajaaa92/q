class JobsController < ApplicationController

  def new
  end

  def order
    @jobs = JobsOrderer.new(params[:jobs]).perform
    render json: {data: @jobs}
  end
end
