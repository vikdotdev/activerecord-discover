class Test
  before_validation :a

  before_validation :b do
  end

  with_options :c do
    before_validation :d
  end

  with_options :e do
    before_validation :f do
    end
  end

  with_options :g do
    before_validation :g

    before_validation :i do
    end
  end
end
