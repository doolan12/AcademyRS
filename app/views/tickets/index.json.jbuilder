json.array!(@tickets) do |ticket|
  json.extract! ticket, :id, :user_id, :status, :assignee_id, :company, :course, :operating_system_id, :browser_id, :description
  json.url ticket_url(ticket, format: :json)
end
