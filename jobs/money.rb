API_URL=ENV['DASHBOARD_FEEDER_URL']

SCHEDULER.every '10s', :first_in => 0 do |job|
  amount = 0
  transactions = 0
  amount_today = 0
  begin
    response = RestClient.get "#{API_URL}/payments"
    data = JSON.parse(response, :symbolize_names => true)
    amount = data[:result][:total_amount].to_i
    amount_today = data[:result][:total_amount_day].to_i
    transactions = data[:result][:total_transactions].to_i
    puts " Got payment data => total: #{amount} today: #{amount_today}"
  rescue => e
    puts "could not fetch money data"
    puts e
  end

  send_event('money', {current: amount})
  #send_event('money', {today: amount_today})
  send_event('total-transactions', {current: transactions})

end
