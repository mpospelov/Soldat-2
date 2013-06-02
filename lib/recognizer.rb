class Recognizer
  @@current_code_row = 0
  def self.start
    @code_rows = File.read('../architecture/result.bin').split("\n")
    while run? do
      puts "Exec #{@@current_code_row}"
      Exec.new(@code_rows[@@current_code_row])
    end
  end

  def self.set_current_code_row(num)
    @@current_code_row = num
  end

  def self.current_code_row
    @@current_code_row
  end

  def self.run?
    @code_rows.count > @@current_code_row
  end

  def self.next
    @@current_code_row += 1
  end
end
