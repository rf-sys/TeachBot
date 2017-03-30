class QueryMaster
  def initialize(klass)
    # entity to query
    @scope = klass

    # defaults
    @params = []
    @actions = [:find, :order]
  end

  def query(request)
    # query params
    @params = request.params

    # generate query
    @params.keys.each do |action|
      @scope = send(action) if @actions.include?(action.to_sym)
    end

    @scope
  end

  # find by specific word or phrase
  def find
    @scope.where("#{find_by} LIKE ?", "%#{@params['find']}%")
  end

  # order result by specific field and order type
  def order
    @scope.order("#{order_by} #{order_type}")
  end

  private

  # get specific field to search if present
  def find_by
    @params['find_by'] if @params.keys.include?('find_by')
  end

  # change order field if present?
  def order_by
    return @params['order_by'] if @params.keys.include?('order_by')
    'created_at'
  end

  # change order type (asc or desc) if present
  def order_type
    return @params['order_type'] if @params.keys.include?('order_type')
    'asc'
  end
end