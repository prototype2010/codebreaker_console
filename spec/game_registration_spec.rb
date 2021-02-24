RSpec.describe GameRegistration do
  let(:registration) { described_class.new }

  it 'creates process if successful' do
    allow(registration).to receive_message_chain(:gets, :chomp, :strip).and_return('easy', 'boris')

    expect(registration.start).to be_an_instance_of(Codebreaker::GameProcess)
  end

  it 'allows to type difficulty correctly' do
    commands = %w[easy22 easy boris]
    allow(registration).to receive_message_chain(:gets, :chomp, :strip).and_return(*commands)

    expect { registration.start }.to output(/Difficulty does not exist/).to_stdout
  end

  it 'allows to type name correctly' do
    commands = %w[easy ni boris]
    allow(registration).to receive_message_chain(:gets, :chomp, :strip).and_return(*commands)

    expect { registration.start }.to output(/Player name length should be between 3 and 20/).to_stdout
  end
end
