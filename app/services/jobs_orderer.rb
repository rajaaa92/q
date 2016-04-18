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
    if @pending_jobs.any?{ |job, previous_job| job == previous_job }
      raise JobsError, 'jobs can’t depend on themselves'
    end
  end

  def order_jobs
    while @pending_jobs.any? do
      @ordered_jobs << find_next_job
    end
  end

  def find_next_job job = nil
    job ||= @pending_jobs.first.first
    if doable?(job)
      @current_depending_jobs = []
      @pending_jobs.delete(job)
      return job
    end
    raise JobsError, "jobs can’t have circular dependencies" if @current_depending_jobs.include?(job)
    @current_depending_jobs << job
    raise JobsError, 'job cannot depend on a job that is not defined' if existing?(job)
    find_next_job(@pending_jobs[job])
  end

  def doable? job
    @pending_jobs[job].blank? || @ordered_jobs.include?(@pending_jobs[job])
  end

  def existing? job
    @pending_jobs.exclude?(@pending_jobs[job])
  end

end

class JobsError < StandardError; end
