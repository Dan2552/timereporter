class Duration

  VALID = [:day, :week, :month, :year]

  def initialize duration, date=nil
    @duration = duration || :week
    @duration = duration.value if duration.is_a? Duration
    @duration = :week if invalid?
    @date = date
  end

  def get_range date=nil
    date ||= @date
    start_date = date.send("beginning_of_#{@duration}").beginning_of_day
    end_date = date.send("end_of_#{@duration}").end_of_day

    start_date..end_date
  end

  def value
    @duration.to_sym
  end

  def valid?
    VALID.include? @duration.to_sym
  end

  def invalid?
    !valid?
  end

end
