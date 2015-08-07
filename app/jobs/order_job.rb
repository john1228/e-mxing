class OrderJob < ActiveJob::Base
  queue_as :default

  def perform(record)
    logger.info record.class
    record.update(contact_name: record.contact_name)
  end
end
