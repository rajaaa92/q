$ ->

  jobs = {}

  addJob = (job, previousJob) ->
    if !job && previousJob
      alert 'gupiś'
    else
      jobs[job] = previousJob
      newNode = '<p>' + job
      if previousJob
        newNode += ' depending on ' + previousJob + '</p>'
      $('center#jobs-list').append(newNode)

  $('.c-form-box form').submit (e) ->
    e.preventDefault()
    job = $('input#c-form-job').val()
    previousJob = $('input#c-form-previousjob').val()
    addJob(job, previousJob)
    $('input#c-form-job').val('')
    $('input#c-form-previousjob').val('')

  $('#order-button').click ->
    $.post('/jobs/order', jobs: jobs)
      .done (res) ->
        alert 'your job order is: ' + res.data
    .fail (e) ->
      alert e.responseJSON.error
