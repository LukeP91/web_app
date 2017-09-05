class TwitterSpawnerWorker
  include Sidekiq::Worker

  def perform
    Source.all.each { |source| TwitterWorker.perform_async(source.id) }
  end
end
