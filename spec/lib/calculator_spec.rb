describe Calculator do

  let(:calculator) { Calculator.new }

  it 'should be able to add two numbers together' do
    expect(calculator.add(4, 5)).to eq(9)
  end

end