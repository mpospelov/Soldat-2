class Address

  @@addresses = 0.upto(200).map{Address.new}

  def initialize
    @value = 0
  end

  def value
    @value.to_i
  end

  def value=(val)
    @value = val
  end

  def self.get(index)
    @@addresses[index]
  end

  def self.print_all_values
    @@addresses.each { |ad| puts ad.value }
  end

end
