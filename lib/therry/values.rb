class Value
  def self.top_n(query, opts={})
    metrics = Metric.find(query)
    period = opts[:period] || "1h"
    time = opts[:time] || "1d"
    n = (opts[:n] || 10).to_i
    targets = metrics.collect do |metric|
      "summarize(#{metric},'#{period}')"
    end
    all_metrics = []
    targets.each_slice(20) do |slice|
      slice_targets = slice.map{|m| "target=#{CGI.escape(m)}"}.join('&')
      puts("TARGETS: #{slice.count} #{slice.first}..#{slice.last}")
      response = RestClient.get("#{Metric.base_url}/render?#{slice_targets}&from=-#{time}&format=json")
      all_metrics += JSON.parse(response).collect do |metric|
        values = metric["datapoints"].map(&:first)
        [metric["target"], values.compact.inject(&:+)]
      end
    end
    all_metrics.select{|m| m.last}.sort_by(&:last).reverse.first(n)
  end
end
