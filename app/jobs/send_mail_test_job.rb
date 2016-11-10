class SendMailTestJob < ApplicationJob
  queue_as :default

  def perform(*args)
     puts "SendMailTest!!!!!!!!!!!"
  end
end
