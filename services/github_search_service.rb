require 'net/http'
require 'json'

class GithubSearchService
  attr_reader :result, :error

  def initialize(search_text)
    @search_text = search_text
    @result      = []
    @error       = nil
  end

  def call
    return if search_text.nil? || search_text.strip.empty?
    unless response["items"].nil?
      @result = response["items"]
    else
      @error = response["error"] || response["message"]
    end
  end

  private

  attr_reader :search_text

  def api_url
    "https://api.github.com/search/repositories?q=#{search_text}"
  end

  def response
    @responce ||= begin
      JSON.parse(Net::HTTP.get(URI(api_url)))
    rescue => e
      {"error" => e.message}
    end
  end
end
