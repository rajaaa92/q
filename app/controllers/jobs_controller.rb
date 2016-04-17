class JobsController < ApplicationController

  def order
    @jobs = JobsOrderer.new(jobs_params).perform
    render json: {data: @jobs}
  end

end
