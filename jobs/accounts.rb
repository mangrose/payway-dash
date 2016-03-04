require 'RestClient'

SCHEDULER.every '10s', :first_in => 0 do |job|
  total_created = 0
  total_activated = 0
  total_created_today = 0
  total_activated_today = 0
  begin
    response = RestClient.get 'http://admin:app161770@localhost:3000/accounts'
    data = JSON.parse(response, :symbolize_names => true)
    total_created = data[:result][:total_created].to_i
    total_created_today = data[:result][:total_created_day].to_i
    total_activated = data[:result][:total_activated].to_i
    total_activated_today = data[:result][:total_activated_day].to_i
  rescue => e
    puts "Could not fetch account data!"
  end

  send_event('total-accounts', {current: total_created})
  send_event('total-accounts', {today: total_created_today})
  send_event('total-activations', {current: total_activated})
  send_event('total-activations', {today: total_activated_today})

end
