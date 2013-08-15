# -*- coding: utf-8 -*-
# = Rakuten
#   シンプルな楽天APIクライアント.
#
require 'cgi'
require 'open-uri'
require 'active_support/inflector'
require 'json'
require 'i18n'

module Rakuten
  class Client
    attr_reader :raw_response

    def initialize(developer_id, affiliate_id = nil, http_opts = {})
      @developer_id, @affiliate_id, @http_opts = developer_id, affiliate_id, http_opts
    end

    # リクエストを実行して結果を返す.
    # 結果はJSONをパーズしたHash.
    # リクエストに失敗したら例外をスローする.
    def request(operation, version = nil, params = {})
      response = open(request_url(operation, version, params), @http_opts) do |f|
        @raw_response = f.read
        JSON.parse(@raw_response)
      end
      return response
      #unless response['Header']['Status'] == 'Success'
      #  raise ApiError.new(response['Header']['Status'], response['Header']['StatusMsg']) 
      #end
      #extract_result(response, operation)
    end

    # リクエストURLを返す.
    def request_url(operation, version = nil, params = {})
      #url = "#{host(operation)}?developerId=#{@developer_id}&operation=#{operation}&version=#{version}"
      url = "#{host(operation)}?applicationId=#{@developer_id}"
      url += "&affiliateId=#{@affiliate_id}" if @affiliate_id && @affiliate_id != ''
      if params
        params.each do |k, v|
          url += "&#{k}=" + CGI::escape(v.to_s)
        end
      end
      #puts url
      url
    end

    # リクエスト送信先ホストを返す.
    def host(operation)
      #'http://api.rakuten.co.jp/rws/3.0/json'
      'https://app.rakuten.co.jp/services/api/IchibaItem/Search/20130805'
    end

    # レスポンスから結果データを抽出する.
    def extract_result(response, operation)
      # Body の子要素は通常は操作名をキーとする要素1つだけのハッシュだが、
      # ProductPriceInfo の場合だけは、キーがItemSearchになっている(バグ?).
      #puts "#{operation}: #{response['Body'].keys.to_s}"
      response['Body'].values[0]
      #response['Body'][operation]
    end

    # 楽天APIにリクエストを送信する.
    # メソッド名が item_ranking であれば、camel case に変換した上で操作名としてリクエストに含める.
    # 第1引数はバージョン文字列、第2引数はパラメターHashであるとする.
    def method_missing(method_id, *params)
      request(method_id.id2name.camelize, params[0], params[1])
    end
  end

  # 楽天トラベル用APIクライアント
  class TravelClient < Client
    def host(operation)
      if ['GetAreaClass', 'GetHotelChainList', 'HotelRanking'].include? operation
        'http://api.rakuten.co.jp/rws/2.0/json'
      else
        super
      end
    end

    def extract_result(response, operation)
      if ['VacantHotelSearch'].include? operation
        response['Body']
      else
        super
      end
    end
  end

  # 楽天ダイナミックアド用APIクライアント
  class DynamicAdClient < Client
    def request_url(operation, version = nil, params = {})
      url = case(operation)
            when 'DynamicAd'
              'http://dynamic.rakuten.co.jp/rcm/1.0/i/json'
            when 'DynamicAdTravel'
              'http://dynamic.rakuten.co.jp/rcm/1.0/t/json'
            end
      url += "?developerId=#{@developer_id}"
      url += "&affiliateId=#{@affiliate_id}" if @affiliate_id && @affiliate_id != ''
      if params
        params.each do |k, v|
          url += "&#{k}=" + CGI::escape(v.to_s)
        end
      end
      #puts url
      url
    end

    def extract_result(response, operation)
      response['Body']
    end
  end

  class ApiError < StandardError
    attr_reader :status, :message
    def initialize(status, message)
      @status, @message = status, message
    end

    def to_s
      "#{self.status}:#{self.message}"
    end
  end
end
