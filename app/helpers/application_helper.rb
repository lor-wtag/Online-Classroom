module ApplicationHelper
  def submission_status(submission)
    if submission.late
      content_tag(:span, "Late", class: "late-submission")
    else
      content_tag(:span, "On Time", class: "on-time-submission")
    end
  end
end
