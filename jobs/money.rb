SCHEDULER.every '5m', :first_in => 0 do |job|
  amount = 0
  transactions = 0
  amount_today = 0
  begin
    response = RestClient.get "#{ENV['DASHBOARD_FEEDER_URL']}/payments"
    data = JSON.parse(response, :symbolize_names => true)
    if data[:status] == 'ok'
      amount = data[:result][:total_amount].to_i
      amount_today = data[:result][:total_amount_day].to_i
      transactions = data[:result][:total_transactions].to_i
    end
  rescue => e
    puts "could not fetch money data"
    puts e.message
  end

  send_event('money', {current: amount})
  send_event('money-today', {current: amount_today})
  send_event('total-transactions', {current: transactions})

end
