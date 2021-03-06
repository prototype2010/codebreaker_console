RSpec.describe GameMediator do
  let(:correct_code_raw) { [1, 2, 3, 4] }
  let(:correct_code) { correct_code_raw.join }
  let(:incorrect_code) { '4444' }

  let!(:game_process) do
    game_process = GameRegistration.new

    allow(game_process).to receive_message_chain(:gets, :chomp, :strip).and_return('easy', 'boris')

    game_process = game_process.start
    game_process.instance_variable_set(:@secret_code, correct_code_raw)
    game_process.instance_variable_set(:@hints, [3, 4])
    game_process
  end

  let(:attempts_left) { game_process.instance_variable_get(:@attempts_left) }
  let(:hints_left) { game_process.instance_variable_get(:@hints).length }

  let(:game_mediator) { described_class.new(game_process) }

  it 'Test instance is correct' do
    expect(game_mediator).to be_an_instance_of(described_class)
  end

  it 'raises error on exit' do
    commands = ['exit']
    allow(game_mediator).to receive_message_chain(:gets, :chomp, :strip).and_return(*commands)

    expect { game_mediator.start }.to raise_error(InterruptGameError)
  end

  it 'asks to input code, hint or exit' do
    commands = ['exit']
    allow(game_mediator).to receive_message_chain(:gets, :chomp, :strip).and_return(*commands)

    expect { game_mediator.start }.to raise_error(InterruptGameError)
      .and output(/Please input you code, take `hint` or `exit`/)
      .to_stdout
  end

  it 'hint is correct' do
    commands = %w[hint hint exit]
    allow(game_mediator).to receive_message_chain(:gets, :chomp, :strip).and_return(*commands)

    expect { game_mediator.start }.to raise_error(InterruptGameError)
      .and output(/4/).to_stdout
  end

  it 'no more hints error is seen' do
    failed_attempts = Array.new(hints_left + 1) { 'hint' }
    commands = failed_attempts.push('exit')
    allow(game_mediator).to receive_message_chain(:gets, :chomp, :strip).and_return(*commands)

    expect { game_mediator.start }.to raise_error(InterruptGameError)
      .and output(/No more hints/).to_stdout
  end

  it 'lose message is seen' do
    failed_attempts = Array.new(attempts_left) { incorrect_code }
    commands = failed_attempts.push('exit')
    allow(game_mediator).to receive_message_chain(:gets, :chomp, :strip).and_return(*commands)

    expect { game_mediator.start }.to raise_error(InterruptGameError)
      .and output(/You lose, dude! Correct code is/).to_stdout
  end

  it 'restart message after lose is seen' do
    failed_attempts = Array.new(attempts_left) { incorrect_code }
    commands = failed_attempts.push('exit')
    allow(game_mediator).to receive_message_chain(:gets, :chomp, :strip).and_return(*commands)

    expect { game_mediator.start }.to raise_error(InterruptGameError)
      .and output(/Would you like to play once more/).to_stdout
  end

  it 'restart error is thrown after lose and restart' do
    failed_attempts = Array.new(attempts_left) { incorrect_code }
    commands = failed_attempts.push('yes')
    allow(game_mediator).to receive_message_chain(:gets, :chomp, :strip).and_return(*commands)

    expect { game_mediator.start }.to raise_error(RestartRequiredError)
  end

  it 'congratulations are seen' do
    commands = [correct_code, 'exit']
    allow(game_mediator).to receive_message_chain(:gets, :chomp, :strip).and_return(*commands)

    expect { game_mediator.start }.to raise_error(InterruptGameError)
      .and output(/Congratulations! Correct code is/).to_stdout
  end

  it 'ask save is seen' do
    commands = [correct_code, 'exit']
    allow(game_mediator).to receive_message_chain(:gets, :chomp, :strip).and_return(*commands)

    expect { game_mediator.start }.to raise_error(InterruptGameError)
      .and output(/Would you like to save the game/).to_stdout
  end

  it 'ask restart is seen' do
    commands = [correct_code, 'yes', 'exit']
    allow(game_mediator).to receive_message_chain(:gets, :chomp, :strip).and_return(*commands)

    expect { game_mediator.start }.to raise_error(InterruptGameError)
      .and output(/Would you like to play once more/).to_stdout
  end

  it 'ask restart triggers game restart' do
    commands = [correct_code, 'yes', 'yes', 'exit']
    allow(game_mediator).to receive_message_chain(:gets, :chomp, :strip).and_return(*commands)

    expect { game_mediator.start }.to raise_error(RestartRequiredError)
  end
end
