class Client
  attr_accessor :name, :status

  def initialize(name, status)
    @name = name
    @status = status
  end

  def update_status(new_status)
    @status = new_status  # No validation, potential hole
  end
  
  def classify_lead
    if @status == 'hot'
      'Priority'
    else
      'Follow up'
    end
  end
end