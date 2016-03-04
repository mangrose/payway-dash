
API_URL=ENV['DASHBOARD_FEEDER_URL']

SCHEDULER.every '10s', :first_in => 0 do |job|
  total_orders = 0
  total_orders_today = 0
  begin
    response = RestClient.get "#{API_URL}/orders"
    data = JSON.parse(response, :symbolize_names => true)
    total_orders = data[:result][:total].to_i
    total_orders_today = data[:result][:total_day].to_i
  rescue => e
    puts "could not fetch order data"
  end
  send_event('total-orders', { current: total_orders })
  send_event('total-orders', {today: total_orders_today})

end
