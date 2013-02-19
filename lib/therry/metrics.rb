class Metric
  @@paths = []

  def self.all
    @@paths
  end

  def self.find(search)
    results = []
    @@paths.each do |p|
      results << p if p.match(/#{search}/i)
    end
   results 
  end

  def self.values(search, opts={})
  end

  def self.load
    self.update
  end

  def self.update
    response = RestClient.get("#{base_url}/metrics/index.json")
    @@paths = JSON.parse(response)
  end
  
  def self.base_url
    u = URI.parse(ENV['GRAPHITE_URL'])
    if (!ENV['GRAPHITE_USER'].empty? && !ENV['GRAPHITE_PASS'].empty?)
      u.user = ENV['GRAPHITE_USER']
      u.password = CGI.escape(ENV['GRAPHITE_PASS'])
    end
    u.to_s
  end
end

