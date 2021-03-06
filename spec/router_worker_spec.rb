RSpec.describe RouterWorker do
  let(:game_start_message) { 'Fake game started' }
  let(:routes) do
    ROUTES.each do |route|
      next unless route[:command] == 'start'

      route[:action] = lambda do
        puts game_start_message
      end
    end
  end
  let(:router) { described_class.new(routes) }

  it 'say hello' do
    expect { router }.to output(/You are welcome to break the code/).to_stdout
  end

  it 'show rotes variant routes' do
    allow(router).to receive_message_chain(:gets, :chomp, :strip).and_return('exit')

    expect { router.work }.to output(/There are available routes/).to_stdout
  end

  it 'say goodbye' do
    allow(router).to receive_message_chain(:gets, :chomp, :strip).and_return('exit')

    expect { router.work }.to output(/Goodbye/).to_stdout
  end

  it 'show rating on stats' do
    allow(router).to receive_message_chain(:gets, :chomp, :strip).and_return('stats', 'exit')

    expect { router.work }.to output(/Rating/).to_stdout
  end

  it 'score will be displayed with no results' do
    FileUtils.delete(Constants::SCORE_FILE_PATH)

    allow(router).to receive_message_chain(:gets, :chomp, :strip).and_return('stats', 'exit')

    expect { router.work }.to output(/Rating/).to_stdout
  end

  it 'show rules on rules' do
    allow(router).to receive_message_chain(:gets, :chomp, :strip).and_return('rules', 'exit')

    expect { router.work }.to output(/Rules/).to_stdout
  end

  it 'starts the game' do
    allow(router).to receive_message_chain(:gets, :chomp, :strip).and_return('start', 'exit')

    expect { router.work }.to output(/#{game_start_message}/).to_stdout
  end
end
