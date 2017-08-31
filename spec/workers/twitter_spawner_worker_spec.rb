require 'rails_helper'

describe TwitterSpawnerWorker do
  it 'saves spawns new worker for each source' do
    Sidekiq::Testing.fake!

    create(:source)
    create(:source)

    expect do
      TwitterSpawnerWorker.new.perform
    end.to change(TwitterWorker.jobs, :size).by(2)
  end
end
