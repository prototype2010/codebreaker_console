RSpec.describe GameStarter do
  context 'when runs normal' do
    let(:registration) do
      double = instance_double('registration')
      allow(double).to receive_message_chain(:new, :start).and_return(double)
      double
    end

    let(:mediator) do
      double = instance_double('mediator')
      allow(double).to receive(:new).with(registration).and_return(double)
      allow(double).to receive(:start).and_return(:mediator)
      double
    end

    let(:starter) { described_class.new(registration, mediator) }

    it 'starts the game' do
      expect(starter.start).to be(:mediator)
    end
  end

  context 'when raises exception' do
    let(:registration) do
      double = instance_double('registration')
      allow(double).to receive_message_chain(:new, :start)
        .and_return(double, nil)
      double
    end

    let(:mediator) do
      double = instance_double('mediator')
      allow(double).to receive(:new).with(registration)
                                    .and_raise(RestartRequiredError)
      allow(double).to receive(:new).with(nil)
                                    .and_raise(InterruptGameError)
      double
    end

    let(:starter) { described_class.new(registration, mediator) }

    it 'restart works fine' do
      expect { starter.start }.to raise_error(InterruptGameError)
    end
  end
end
