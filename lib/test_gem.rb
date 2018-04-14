require 'test_gem/version'
require 'net/http'
require 'uri'
require 'json'

module TestGem
  extend self
  private

  @uri = URI.parse('https://api.bitflyer.jp')
  @market_aliases = {BTCJPY_MAT1WK: 'MATJPY01SEP2017', BTCJPY_MAT2WK: 'BTCJPY08SEP2017'}


  def self.https_get(uri)
    https = Net::HTTP.new(uri.host, uri.port)
    https.use_ssl = true
    https.get uri.request_uri
  end

  public

  def self.markets
    @uri.path = '/v1/getmarkets'

    response = https_get(@uri)
    markets = JSON.parse(response.body, symbolize_names: true)
    markets.map { |market|
      if market.has_key?(:alias)
        market[:alias]
      else
        market[:product_code]
      end
    }
  end

  def self.board(market = 'BTC_JPY')
    @uri.path = '/v1/getboard'
    market_alias = market.to_sym
    market = @market_aliases.has_key?(market_alias) ? @market_aliases[market_alias] : market
    @uri.query = "product_code=#{market}"

    response = https_get(@uri)
    JSON.parse(response.body, symbolize_names: true)
  end

  def self.ticker(market = 'BTC_JPY')
    @uri.path = '/v1/getticker'
    market_alias = market.to_sym
    market = @market_aliases.has_key?(market_alias) ? @market_aliases[market_alias] : market
    @uri.query = "product_code=#{market}"

    response = https_get(@uri)
    JSON.parse(response.body, symbolize_names: true)
  end

  def self.executions(market = 'BTC_JPY', count = 100, before = 0, after = 0)
    @uri.path = '/v1/getexecutions'
    market_alias = market.to_sym
    market = @market_aliases.has_key?(market_alias) ? @market_aliases[market_alias] : market
    @uri.query = "product_code=#{market}&count=#{count}&before=#{before}&after=#{after}"

    response = https_get(@uri)
    JSON.parse(response.body, symbolize_names: true)
  end

  def self.chats(option = '')
    @uri.path = '/v1/getchats'
    @uri.query = "form_date=#{option}"

    response = https_get(@uri)
    JSON.parse(response.body, symbolize_names: true)
  end

  def self.health
    @uri.path = '/v1/gethealth'

    response = https_get(@uri)
    JSON.parse(response.body, symbolize_names: true)
  end

  def self.prices
    @uri.path = '/v1/getprices'

    response = https_get(@uri)
    JSON.parse(response.body, symbolize_names: true)
  end
end
