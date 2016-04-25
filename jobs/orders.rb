
SCHEDULER.every '5m', :first_in => 0 do |job|
  total_orders = 0
  total_orders_today = 0
  begin
    response = RestClient.get "#{ENV['DASHBOARD_FEEDER_URL']}/orders"
    data = JSON.parse(response, :symbolize_names => true)
    if data[:status] == 'ok'
      total_orders = data[:result][:total].to_i
      total_orders_today = data[:result][:total_day].to_i
    end
  rescue => e
    puts "could not fetch order data"
    puts e.message
  end
  send_event('total-orders', { current: total_orders })
  send_event('orders-today', {current: total_orders_today})

end
