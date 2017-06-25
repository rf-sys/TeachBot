class RedisSingleton
  @@instance = nil

  # @return [Redis.new]
  def self.instance
    @@instance ||= Redis.new
  end

  private_class_method :new
end
