class JobsOrderer

  def initialize jobs_params
    @jobs_params = jobs_params
    @pending_jobs = {}
    @ordered_jobs = []
    @current_depending_jobs = []
  end

  def perform
    normalize_input
    order_jobs
    @ordered_jobs.join
  end

  private

  def normalize_input
    @jobs_params.each do |job_array|
      raise 'jobs can’t depend on themselves' if job_array.first == job_array.last
      @pending_jobs[job_array.first] = job_array.last
    end
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
      @pending_jobs.delete(job)
      return job
    else
      raise "jobs can’t have circular dependencies" if @current_depending_jobs.include?(job)
      @current_depending_jobs << job
      find_next_job(@pending_jobs[job])
    end
  end

  def doable? job
    @pending_jobs[job].nil? || @ordered_jobs.include?(@pending_jobs[job])
  end

end


