class TwitterSpawnerWorker
  def perform
    Source.all.each { |source| TwitterWorker.perform_async(source) }
  end
end
