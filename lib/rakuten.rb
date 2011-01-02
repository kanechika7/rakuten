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
    def initialize(developer_id, affiliate_id = nil)
      @developer_id, @affiliate_id = developer_id, affiliate_id
      @host = 'http://api.rakuten.co.jp/rws/3.0/json'
    end

    # リクエストを実行して結果を返す.
    # 結果はJSONをパーズしたHash.
    # リクエストに失敗したら例外をスローする.
    def request(operation, version = nil, params = {})
      response = open(request_url(operation, version, params)) do |f|
        JSON.parse(f.read)
      end
      raise response['Header']['StatusMsg'] unless response['Header']['Status'] == 'Success'
      response
    end

    # リクエストURLを返す.
    def request_url(operation, version = nil, params = {})
      url = "#{@host}?developerId=#{@developer_id}&operation=#{operation}&version=#{version}"
      url += "&affiliateId=#{affiliate_id}" if @affiliate_id
      params.each do |k, v|
        url += "&#{k}=" + CGI::escape(v.to_s)
      end
      url
    end

    # 楽天APIにリクエストを送信する.
    # メソッド名が item_ranking であれば、camel case に変換した上で操作名としてリクエストに含める.
    # 第1引数はバージョン文字列、第2引数はパラメターHashであるとする.
    def method_missing(method_id, *params)
      request(method_id.id2name.camelize, params[0], params[1])
    end
  end
end
