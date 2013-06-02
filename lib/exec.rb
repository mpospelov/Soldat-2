class Exec
  attr_accessor :command, :op1_type, :op1_value, :op2_type, :op2_value
  @@commands = [:add, :sub, :div, :mul, :and, :or, :mov, :shr, :shl, :jz, :jn, :jmp, :inc, :dec, :stop, :not]

  def initialize(str)
    @command = str[0..3].to_i(2)
    @op1_type = str[4..5].to_i(2)
    @op1_value = str[6..17].to_i(2)
    @op2_type = str[18..19].to_i(2)
    @op2_value = str[20..32].to_i(2)
    exec
  end

  private

  def exec
    send(recognize_coomand, recognize_op1, recognize_op2)
    Recognizer.next
  end

  def recognize_coomand
    @@commands[@command]
  end

  def recognize_op1
    case @op1_type
    when 0
      @op1_value
    when 1
      Address.get(@op1_value)
    when 2
      Address.get(@op1_value)
    when 3
      Address.get Address.get(@op1_value).value
    end
  end

  def recognize_op2
    case @op2_type
    when 0
      @op2_value
    when 1
      Address.get(@op2_value)
    when 2
      Address.get(@op2_value)
    when 3
      Address.get Address.get(@op2_value).value
    end
  end

  def add(op1, op2)
    op1.value += op2.respond_to?(:value) ? op2.value : op2
  end

  def sub(op1, op2)
    op1.value -= op2.respond_to?(:value) ? op2.value : op2
  end

  def div(op1, op2)
    op1.value /= op2.respond_to?(:value) ? op2.value : op2
  end

  def mul(op1, op2)
    op1.value *= op2.respond_to?(:value) ? op2.value : op2
  end

  def and(op1, op2)
    op1.value &= op2.respond_to?(:value) ? op2.value : op2
  end

  def or(op1, op2)
    op1.value |= op2.respond_to?(:value) ? op2.value : op2
  end

  def mov(op1, op2)
    op1.value = op2.respond_to?(:value) ? op2.value : op2
  end

  def shr(op1, op2)
    op1.value >>=1
  end

  def shl(op1, op2)
    op1.value <<=1
  end

  def jz(op1, op2)
    value = op1.respond_to?(:value) ? op1.value : op1
    if value == 0
      set = (op2.respond_to?(:value) ? op2.value : op2) - 1
      Recognizer.set_current_code_row(set)
    end
  end

  def jn(op1, op2)
    value = op1.respond_to?(:value) ? op1.value : op1
    if value < 0
      set = (op2.respond_to?(:value) ? op2.value : op2) - 1
      Recognizer.set_current_code_row(set)
    end
  end

  def jmp(op1, op2)
    set = (op1.respond_to?(:value) ? op1.value : op1) - 1
    Recognizer.set_current_code_row(set)
  end

  def inc(op1, op2)
    op1.value += 1
  end

  def dec(op1, op2)
    op1.value -= 1
  end

  def stop(op1, op2)
    Recognizer.set_current_code_row(1000)
  end

  def not(op1, op2)
    op1.value = ~op1.value
  end

end
