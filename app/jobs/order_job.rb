class OrderJob < ActiveJob::Base
  queue_as :default

  def perform(order_id)
    order = Order.find_by(id: order_id)
    order.update(contact_name: record.contact_name + Date.today.strftime('%Y%m%d'))
  end
end
