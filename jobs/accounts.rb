SCHEDULER.every '5m', :first_in => 0 do |job|
  total_created = 0
  total_activated = 0
  total_created_today = 0
  total_activated_today = 0
  begin
    url = "#{ENV['DASHBOARD_FEEDER_URL']}/accounts"
    response = RestClient.get url
    data = JSON.parse(response, :symbolize_names => true)
    if data[:status] == 'ok'
      total_created = data[:result][:total_created].to_i
      total_created_today = data[:result][:total_created_day].to_i
      total_activated = data[:result][:total_activated].to_i
      total_activated_today = data[:result][:total_activated_day].to_i
    end
  rescue => e
    puts "Could not fetch account data!"
    puts e.message
  end

  send_event('total-accounts', {current: total_created})
  send_event('accounts-today', {current: total_created_today})
  send_event('total-activations', {current: total_activated})
  send_event('activations-today', {current: total_activated_today})

end
