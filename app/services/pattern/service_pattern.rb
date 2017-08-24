class Pattern::ServicePattern
  attr_reader :result

  def self.call(*params)
    instance = new(*params)
    instance.super_call
    instance
  end

  def super_call
    @result = call
  end
end
