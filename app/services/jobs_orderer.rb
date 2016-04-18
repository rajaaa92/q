class JobsOrderer

  def initialize jobs_params
    @pending_jobs = jobs_params
    @ordered_jobs = []
    @current_depending_jobs = []
  end

  def perform
    validate_input
    order_jobs
    @ordered_jobs.join
  end

  private

  def validate_input
    raise 'jobs can’t depend on themselves' if @pending_jobs.any?{ |job, previous_job| job == previous_job }
  end

  def order_jobs
    while @pending_jobs.any? do
      @ordered_jobs << find_next_job
    end
  end

  def find_next_job job = nil
    job ||= @pending_jobs.first.first
    if doable(job)?
      @current_depending_jobs = []
      binding.pry
      @pending_jobs.delete(job)
      return job
    end
    raise "jobs can’t have circular dependencies" if @current_depending_jobs.include?(job)
    @current_depending_jobs << job
    find_next_job(@pending_jobs[job])
  end

  def doable? job
    @pending_jobs[job].empty? || @ordered_jobs.include?(@pending_jobs[job])
  end

end


