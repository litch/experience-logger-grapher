require 'time'

class Array
  def sum
    inject(0.0) { |result, el| result + el.exp }
  end

  def mean_exp
    sum / size
  end
end

class ExpLogParser
  attr_accessor :data

  def initialize(name)
    @data = []
    IO.foreach("../lich/log/#{name}.log") {|l| parseline(l) }
  end

  def parseline(line)
    if datum = DataPoint.from_row(line)
      @data << datum
      populate_running_average
    end
  end

  def populate_running_average
    @data.last.running_average = @data.last(8).mean_exp
  end
end

class DataPoint
  attr_accessor :exp, :time, :level, :running_average

  def initialize(exp: exp, level: level, time: time)
    self.exp = exp
    self.level = level
    self.time = time
  end

  def to_json(*)
    {exp: exp, level: level, time: time.to_i*1000, running_average: running_average}.to_json
  end

  def self.from_row(row)
    row_info = row.split(" ")
    return unless row_info[0] =~ /\d\d\d\d-\d\d-\d\d/
    row =~ /Level: (\d+)/
    DataPoint.new(exp: row_info[9].to_i, level: $1.to_i, time: Time.parse("#{row_info[0]} #{row_info[1]}"))
  end

  def self.sum_exps(data)
    data.map(&:exp).inject(0, :+)
  end
end


