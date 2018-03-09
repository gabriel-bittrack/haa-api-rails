class GeocodeScholarProcessor < SyncProcessor
  def initialize(current_user)
    @current_user = current_user
  end

  def process
    puts ">>>> let the processing begin"
    # scholars = Scholar.pluck(:id)
    scholars = Scholar.where('lat is null').pluck(:id)
    puts ">>>> process these ids : #{scholars}"
    ScholarCoordinatesWorker.perform_async(scholars)
  end
end