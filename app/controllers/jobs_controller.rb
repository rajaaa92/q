class JobsController < ApplicationController

  def new
  end

  def order
    @jobs = JobsOrderer.new(jobs_params).perform
    render json: {data: @jobs}
  end

end
