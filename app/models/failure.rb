class Failure
  def initialize(message)
    @message = message
  end

  def as_json(options={})
    {
        code: 0,
        message: @message
    }
  end
end